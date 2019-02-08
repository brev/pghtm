/**
 * Synapse Functions
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
  query_link CONSTANT TEXT :=
    'INSERT INTO htm.link_distal_cell_synapse (cell_id, synapse_id) VALUES %s';
  query_synapse CONSTANT TEXT := $sql$
    WITH synapse_new AS (
      INSERT INTO htm.synapse (segment_id, permanence)
        VALUES %s
        RETURNING id
    ) SELECT ARRAY(
      SELECT id FROM synapse_new
    );
  $sql$;
  permanence CONSTANT NUMERIC :=
    htm.config('synapse_distal_threshold')::NUMERIC +
    htm.config('synapse_distal_increment')::NUMERIC;
  recents_length CONSTANT INT := COALESCE(ARRAY_LENGTH(recents, 1), 0);
  segments_length CONSTANT INT := COALESCE(ARRAY_LENGTH(segments, 1), 0);
  insert_count INT;
  new_rows TEXT[];
  new_sql TEXT;
  synapses INT[];
  synapses_length INT;
BEGIN
  FOR index IN 1..segments_length LOOP
    -- how many synapses? least of: # needed, and # until max/segment
    insert_count = LEAST(openings[index], recents_length);
    new_rows := ARRAY[]::TEXT[];

    PERFORM htm.debug('..TM growing new synapses on new segment');
    -- TODO this should be some random sub-pct, not all
    FOR recent_index IN 1..insert_count LOOP
      new_rows := ARRAY_APPEND(
        new_rows,
        FORMAT('(%L, %L)', segments[index], permanence)
      );
    END LOOP;
    new_sql := FORMAT(query_synapse, ARRAY_TO_STRING(new_rows, ','));
    EXECUTE new_sql INTO synapses;
    synapses_length := COALESCE(ARRAY_LENGTH(synapses, 1), 0);

    PERFORM htm.debug('..TM growing new links from prev cells => new synapses');
    new_rows := ARRAY[]::TEXT[];
    FOR index IN 1..synapses_length LOOP
      new_rows := ARRAY_APPEND(
        new_rows,
        FORMAT('(%L, %L)', recents[index], synapses[index])
      );
    END LOOP;
    new_sql := FORMAT(query_link, ARRAY_TO_STRING(new_rows, ','));
    EXECUTE new_sql;
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
      JOIN htm.link_distal_segment_cell AS ldsc
        ON ldsc.cell_id = ca.id
      JOIN htm.segment_distal_anchor AS sda
        ON sda.id = ldsc.segment_id
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
      LEFT JOIN link_distal_cell_synapse AS ldcs
        ON ldcs.cell_id = c.id
      LEFT JOIN synapse AS s
        ON s.id = ldcs.synapse_id
      LEFT JOIN link_distal_segment_cell AS ldsc
        ON ldsc.segment_id = s.segment_id
      LEFT JOIN cell_anchor AS ca
        ON ca.id = ldsc.cell_id
      WHERE c.active_last
      AND ca.id IS NULL
    ) INTO recents;

  -- Perform learning on existing synapses before growing anything new.
  PERFORM htm.debug('TM learning anchor cells doing distal synaptic learning');
  WITH synapse_next AS (
    SELECT
      s.id,
      (CASE
        WHEN c.active_last THEN
          htm.synapse_distal_get_increment(s.permanence)
        ELSE
          htm.synapse_distal_get_decrement(s.permanence)
      END) AS permanence
    FROM htm.synapse AS s
    JOIN htm.link_distal_segment_cell AS ldsc
      ON ldsc.segment_id = s.segment_id
    JOIN htm.cell_anchor AS ca
      ON ca.id = ldsc.cell_id
      AND NOT ca.segment_grow
    LEFT JOIN htm.link_distal_cell_synapse AS ldcs
      ON ldcs.synapse_id = s.id
    LEFT JOIN htm.cell AS c
      ON c.id = ldcs.cell_id
  )
  UPDATE htm.synapse AS s
    SET permanence = sn.permanence
    FROM synapse_next AS sn
    WHERE sn.id = s.id;

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
      s.id,
      htm.synapse_distal_get_decrement(s.permanence) AS permanence
    FROM synapse AS s
    JOIN link_distal_segment_cell AS ldsc
      ON ldsc.segment_id = s.segment_id
    JOIN cell_predict AS cp
      ON cp.id = ldsc.cell_id
    JOIN htm.column AS col
      ON col.id = cp.column_id
      AND NOT col.active
  )
  UPDATE htm.synapse AS s
    SET permanence = sn.permanence
    FROM synapse_next AS sn
    WHERE sn.id = s.id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/**
 * Make sure segments have a unique synaptic connection to each cell axon.
 *  No pre-synaptic cell should connect (with synapses) to the same
 *  post-synaptic segment twice or more. Remove any orphan synapses
 *  that might have been created just previously, and will no longer be valid.
 * @TemporalMemory
 */
CREATE FUNCTION htm.synapse_distal_segment_unique_update()
RETURNS TRIGGER
AS $$
DECLARE
  allowed BOOL;
BEGIN
  -- already exists on segment?
  SELECT (COUNT(s.id) = 0)
    INTO allowed
    FROM htm.synapse AS s
    JOIN link_distal_cell_synapse AS ldcs
      ON ldcs.synapse_id = s.id
      AND ldcs.cell_id = NEW.cell_id
    WHERE s.segment_id = (
      SELECT s.segment_id
      FROM htm.synapse AS s
      WHERE s.id = NEW.synapse_id
    );

  IF allowed THEN
    -- allowed, put it in
    RETURN NEW;
  ELSE
    -- not allowed, already exists: remove any orphan synapses
    PERFORM htm.debug('....TM skip duplicate segment distal link and clean');
    DELETE
      FROM synapse AS s
      WHERE s.id = NEW.synapse_id;
    -- and skip
    RETURN NULL;
  END IF;
END;
$$ LANGUAGE plpgsql;

/**
 * Perform the overlapDutyCycle/synaptic-related parts of boosting.
 *  Promote underwhelmed columns via synaptic permanence increase to
 *  stoke future wins.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_proximal_boost_update()
RETURNS TRIGGER
AS $$
DECLARE
BEGIN
  PERFORM htm.debug('SP performing proximal synaptic boosting');
  WITH synapse_next AS (
    SELECT
      s.id,
      htm.synapse_proximal_get_increment(s.permanence) AS permanence
    FROM htm.synapse AS s
    JOIN htm.segment AS seg
      ON seg.id = s.segment_id
      AND seg.class = 'proximal'
    JOIN htm.link_proximal_segment_column AS lpsc
      ON lpsc.segment_id = seg.id
    JOIN htm.column AS c
      ON c.id = lpsc.column_id
    JOIN htm.region AS r
      ON r.id = c.region_id
      AND r.duty_cycle_overlap_mean > c.duty_cycle_overlap
  )
  UPDATE htm.synapse AS s
    SET permanence = sn.permanence
    FROM synapse_next AS sn
    WHERE sn.id = s.id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/**
 * Check if a proximal synapse is considered connected (above permanence
 *  threshold) or not (potential).
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_proximal_get_connection(permanence NUMERIC)
RETURNS BOOL
AS $$
DECLARE
  synapse_proximal_threshold CONSTANT NUMERIC :=
    htm.config('synapse_proximal_threshold');
BEGIN
  RETURN permanence > synapse_proximal_threshold;
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Nudge proximal potential synapse permanence down according to learning rules.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_proximal_get_decrement(permanence NUMERIC)
RETURNS NUMERIC
AS $$
DECLARE
  decrement CONSTANT NUMERIC := htm.config('synapse_proximal_decrement');
BEGIN
  RETURN GREATEST(permanence - decrement, 0.0);
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Nudge proximal connected synapse permanence up according to learning rules.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_proximal_get_increment(permanence NUMERIC)
RETURNS NUMERIC
AS $$
DECLARE
  increment CONSTANT NUMERIC := htm.config('synapse_proximal_increment');
BEGIN
  RETURN LEAST(permanence + increment, 1.0);
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Perform Hebbian-style learning on proximal synapse permanences. This is
 *  based on recently-actived winner column, triggered from an update on
 *  the `column.active` field.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_proximal_learn_update()
RETURNS TRIGGER
AS $$
DECLARE
BEGIN
  PERFORM htm.debug('SP performing proximal synaptic learning');
  WITH synapse_next AS (
    SELECT
      s.id,
      (CASE
        WHEN spa.id IS NOT NULL
          THEN htm.synapse_proximal_get_increment(s.permanence)
        ELSE
          htm.synapse_proximal_get_decrement(s.permanence)
      END) AS permanence
    FROM htm.synapse AS s
    LEFT JOIN htm.synapse_proximal_active AS spa
      ON spa.id = s.id
    JOIN htm.segment AS d
      ON d.id = s.segment_id
      AND d.class = 'proximal'
    JOIN htm.link_proximal_segment_column AS lpsc
      ON lpsc.segment_id = d.id
    JOIN htm.column AS c
      ON c.id = lpsc.column_id
      AND c.active
  )
  UPDATE htm.synapse AS s
    SET permanence = sn.permanence
    FROM synapse_next AS sn
    WHERE sn.id = s.id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

