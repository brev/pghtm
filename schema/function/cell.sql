/**
 * Cell Functions
 */


/**
 * Update cell activity flags based on recently selected active winner
    columns from the SP.
 * @TemporalMemory
 */
CREATE FUNCTION htm.cell_active_update()
RETURNS TRIGGER
AS $$
BEGIN
  PERFORM htm.debug('TM updating cell activity state via bursting/predicted');
  WITH cell_next AS (
    WITH column_predict AS (
      SELECT DISTINCT(cp.column_id) AS id
      FROM htm.cell_predict AS cp
      JOIN htm.column AS col
        ON col.id = cp.column_id
        AND col.active
    )
    SELECT
      cell.id,
      (CASE
        WHEN (COUNT(cell_predict.id) > 0) THEN
          TRUE  -- predicted => active
        WHEN (
          (column_predict.id IS NULL) AND
          (COUNT(cell_burst.id) > 0)
        ) THEN
          TRUE  -- bursting => active
        ELSE
          FALSE  -- not predict, not burst, nor bursting with predicted column
      END) AS active
    FROM htm.cell
    LEFT JOIN column_predict
      ON column_predict.id = cell.column_id
    LEFT JOIN htm.cell_predict
      ON cell_predict.id = cell.id
    LEFT JOIN htm.cell_burst
      ON cell_burst.id = cell.id
    GROUP BY
      cell.id,
      column_predict.id
  )
  UPDATE htm.cell
    SET active = cell_next.active
    FROM cell_next
    WHERE cell_next.id = cell.id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/**
 * When `cell.active` is updating, we'll store it's now-previous value into
 *  the `call.active_last` field. This is for the TM to extend back into time.
 * @TemporalMemory
 */
CREATE FUNCTION htm.cell_active_last_update()
RETURNS TRIGGER
AS $$
BEGIN
  NEW.active_last = OLD.active;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/**
 * Grow new segemnts/synapses on appropriate learning anchor cells.
 * @TemporalMemory
 */
CREATE FUNCTION htm.cell_anchor_segment_synapse_grow_update()
RETURNS TRIGGER
AS $$
DECLARE
  permanence CONSTANT NUMERIC :=
    htm.config('synapse_distal_threshold')::NUMERIC +
    htm.config('synapse_distal_increment')::NUMERIC;
  anchors INT[];
  anchor_id INT;
  anchor_index INT;
  anchors_length INT;
  recents INT[];
  recent_id INT;
  recent_index INT;
  recents_length INT;
  segment_id INT;
  synapse_id INT;
BEGIN
  SELECT ARRAY(
    SELECT ca.id
    FROM htm.cell_anchor AS ca
    WHERE ca.segment_grow
  ) INTO anchors;
  anchors_length = COALESCE(array_length(anchors, 1), 0);

  SELECT ARRAY(
    SELECT c.id
    FROM htm.cell AS c
    WHERE c.active_last
  ) INTO recents;
  recents_length = COALESCE(array_length(recents, 1), 0);

  IF (
    (anchors_length > 0) AND
    (recents_length > 0)
  ) THEN
    PERFORM
      htm.debug('TM growing new segments/synapses on learning anchor cells');
    FOR anchor_index IN 1..anchors_length LOOP
      anchor_id := anchors[anchor_index];

      PERFORM htm.debug('..TM growing new segment');
      INSERT INTO htm.segment (class)
        VALUES ('distal')
        RETURNING id INTO segment_id;
      INSERT INTO htm.link_distal_segment_cell (segment_id, cell_id)
        VALUES (segment_id, anchor_id);

      PERFORM
        htm.debug('..TM growing new synapses');
      -- TODO this should be some random sub-pct, not all
      FOR recent_index IN 1..recents_length LOOP
        recent_id := recents[recent_index];

        INSERT INTO htm.synapse (segment_id, permanence)
          VALUES (segment_id, permanence)
          RETURNING id INTO synapse_id;
        INSERT INTO htm.link_distal_cell_synapse (cell_id, synapse_id)
          VALUES (recent_id, synapse_id);
      END LOOP;
    END LOOP;
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/**
 * Check if a cell is predictive (# active distal segments above threshold).
 *  Threshold of 1 is the same as NuPIC's logical OR.
 * @TemporalMemory
 */
CREATE FUNCTION htm.cell_is_predict(segments_active INT)
RETURNS BOOL
AS $$
DECLARE
  threshold CONSTANT INT := htm.config('cell_segment_threshold');
BEGIN
  RETURN segments_active > threshold;
END;
$$ LANGUAGE plpgsql STABLE;

