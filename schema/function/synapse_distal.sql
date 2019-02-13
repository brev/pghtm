/**
 * Synapse (Distal) Functions
 */


/**
 * Grow synapses on learning anchor cells. This is both for those learning
 *  anchor cells which did not already have them (new segments for these were
 *  just grown in the preceding function), and for anchor cells that already
 *  had good segments but were missing a few new synapses (learning was
 *  performed in the preceding function on current synapses).
 * @TemporalMemory
 */
CREATE FUNCTION htm.synapse_distal_anchor_grow_updates(
  segments INT[],  -- segment list to grow synapses on
  openings INT[],  -- # of openings for new synapse growth on each segment
  recents INT[]    -- pre-synaptic source cell axons for other side of connect
)
RETURNS BOOL
AS $$
DECLARE
  query_synapse CONSTANT TEXT := $sql$
    INSERT INTO htm.synapse_distal
      (input_cell_id, permanence, segment_id)
      VALUES %s
  $sql$;
  permanence CONSTANT NUMERIC :=
    htm.config('synapse_distal_threshold')::NUMERIC +
    htm.config('synapse_distal_increment')::NUMERIC;
  recents_length CONSTANT INT := COALESCE(ARRAY_LENGTH(recents, 1), 0);
  segments_length CONSTANT INT := COALESCE(ARRAY_LENGTH(segments, 1), 0);
  insert_count INT;
  new_rows TEXT[];
  new_sql TEXT;
  recents_copy INT[];
  recent_cell_id INT;
BEGIN
  FOR segment_index IN 1..segments_length LOOP
    PERFORM htm.debug('..TM growing new synapses');
    -- fresh copy of recents to slowly and randomly eat
    recents_copy := recents;
    new_rows := ARRAY[]::TEXT[];
    -- how many synapses? least of: # needed, and # until max/segment
    insert_count = LEAST(openings[segment_index], recents_length);

    FOR recent_index IN 1..insert_count LOOP
      -- pop a random source cell axon off the list
      recent_cell_id := recents_copy[
        htm.random_range_int(1, COALESCE(ARRAY_LENGTH(recents_copy, 1), 0))
      ];
      recents_copy := ARRAY_REMOVE(recents_copy, recent_cell_id);
      -- build sql
      new_rows := ARRAY_APPEND(
        new_rows,
        FORMAT(
          '(%L, %L, %L)',
          recent_cell_id,
          permanence,
          segments[segment_index]
        )
      );
    END LOOP;
    BEGIN
      -- try
      new_sql := FORMAT(query_synapse, ARRAY_TO_STRING(new_rows, ','));
      EXECUTE new_sql;
    EXCEPTION WHEN unique_violation THEN
      -- catch
      RETURN NULL;
    END;
  END LOOP;

  RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

/**
 * Learn on learning anchor cells which already had good segments/synapses.
 *  Bump up synapses connected to active_last cells, and bump down the rest
 *  of these. Add any new synapses needed for possible new input.
 * @TemporalMemory
 */
CREATE FUNCTION htm.synapse_distal_anchor_learn_update()
RETURNS TRIGGER
AS $$
DECLARE
  synapse_max CONSTANT INT := htm.config('synapse_distal_count');
  openings INT[];
  recents INT[];
  segments INT[];
BEGIN
  -- Detect synapse growth variables before learning, since learning might
  --  change the data out from under us. TODO Order this function more
  --  sanely once/if views are materialized.
  -- Get post-synaptic anchor learning segments w/count of free synapse slots.
  WITH segment_anchor
    AS (
      SELECT
        sda.id,
        (synapse_max - sda.synapse_count) AS synapse_free
      FROM htm.cell_anchor AS ca
      JOIN htm.segment AS s
        ON s.cell_id = ca.id
      JOIN htm.segment_anchor AS sda
        ON sda.id = s.id
        AND sda.order_id = 1
      WHERE NOT ca.segment_grow
    )
    SELECT
      ARRAY(
        SELECT sa.id
        FROM segment_anchor AS sa
        ORDER BY sa.id
      ) AS id,
      ARRAY (
        SELECT sa.synapse_free
        FROM segment_anchor AS sa
        ORDER BY sa.id
      ) AS synapse_free
    INTO segments, openings;
  -- Get pre-synaptic prev-active cells for other side of connection.
  SELECT
    ARRAY(
      SELECT DISTINCT(c.id)
      FROM htm.cell AS c
      LEFT JOIN htm.synapse_distal AS sd
        ON sd.input_cell_id = c.id
      LEFT JOIN htm.segment AS s
        ON s.id = sd.segment_id
      LEFT JOIN htm.cell_anchor AS ca
        ON ca.id = s.cell_id
      WHERE c.active_last
      AND ca.id IS NULL
    ) INTO recents;

  -- Perform learning on existing synapses before growing anything new.
  PERFORM htm.debug('TM learning anchor cells doing distal synaptic learning');
  WITH synapse_next AS (
    SELECT
      sd.id,
      (CASE
        WHEN c.active_last THEN
          htm.synapse_distal_get_increment(sd.permanence)
        ELSE
          htm.synapse_distal_get_decrement(sd.permanence)
      END) AS permanence
    FROM htm.synapse_distal AS sd
    JOIN htm.segment AS s
      ON s.id = sd.segment_id
    JOIN htm.cell_anchor AS ca
      ON ca.id = s.cell_id
      AND NOT ca.segment_grow
    LEFT JOIN htm.cell AS c
      ON c.id = sd.input_cell_id
  )
  UPDATE htm.synapse_distal AS sd
    SET permanence = sn.permanence
    FROM synapse_next AS sn
    WHERE sn.id = sd.id;

  -- Now that learning is done we grow new synapses. Data comes from
  --  very top of this function, before learning (which may have
  --  negatively impacted that data (views) since).
  IF (
    (COALESCE(ARRAY_LENGTH(segments, 1), 0) > 0) AND
    (COALESCE(ARRAY_LENGTH(recents, 1), 0) > 0)
  ) THEN
    PERFORM htm.debug('TM after learn anchor cells grow any missing synapses');
    PERFORM htm.synapse_distal_anchor_grow_updates(segments, openings, recents);
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/**
 * Check if a distal synapse is considered connected (above permanence
 *  threshold) or not (potential).
 * @TemporalMemory
 */
CREATE FUNCTION htm.synapse_distal_get_connection(permanence NUMERIC)
RETURNS BOOL
AS $$
DECLARE
  synapse_distal_threshold CONSTANT NUMERIC :=
    htm.config('synapse_distal_threshold');
BEGIN
  RETURN permanence > synapse_distal_threshold;
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Nudge distal potential synapse permanence down according to learning rules.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_distal_get_decrement(permanence NUMERIC)
RETURNS NUMERIC
AS $$
DECLARE
  decrement CONSTANT NUMERIC := htm.config('synapse_distal_decrement');
BEGIN
  RETURN GREATEST(permanence - decrement, 0.0);
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Nudge distal connected synapse permanence up according to learning rules.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_distal_get_increment(permanence NUMERIC)
RETURNS NUMERIC
AS $$
DECLARE
  increment CONSTANT NUMERIC := htm.config('synapse_distal_increment');
BEGIN
  RETURN LEAST(permanence + increment, 1.0);
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Punish synapses on predict cells that did not become active.
 * @TemporalMemory
 */
CREATE FUNCTION htm.synapse_distal_nonpredict_punish_update()
RETURNS TRIGGER
AS $$
DECLARE
  decrement CONSTANT NUMERIC := htm.config('synapse_distal_decrement');
BEGIN
  PERFORM htm.debug('TM punishing predicted cells not in active columns');
  WITH synapse_next AS (
    SELECT
      sd.id,
      htm.synapse_distal_get_decrement(sd.permanence) AS permanence
    FROM htm.synapse_distal AS sd
    JOIN htm.segment AS s
      ON s.id = sd.segment_id
    JOIN htm.cell_predict AS cp
      ON cp.id = s.cell_id
    JOIN htm.column AS col
      ON col.id = cp.column_id
      AND NOT col.active
  )
  UPDATE htm.synapse_distal AS sd
    SET permanence = sn.permanence
    FROM synapse_next AS sn
    WHERE sn.id = sd.id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

