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
      c.id,
      (CASE
        WHEN (COUNT(cp.id) > 0) THEN
          TRUE  -- predicted => active
        WHEN (
          (colp.id IS NULL) AND
          (COUNT(cb.id) > 0)
        ) THEN
          TRUE  -- bursting => active
        ELSE
          FALSE  -- not predict, not burst, nor bursting with predicted column
      END) AS active
    FROM htm.cell AS c
    LEFT JOIN column_predict AS colp
      ON colp.id = c.column_id
    LEFT JOIN htm.cell_predict AS cp
      ON cp.id = c.id
    LEFT JOIN htm.cell_burst AS cb
      ON cb.id = c.id
    GROUP BY
      c.id,
      colp.id
  )
  UPDATE htm.cell AS c
    SET active = cn.active
    FROM cell_next AS cn
    WHERE cn.id = c.id;

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
CREATE FUNCTION htm.cell_anchor_synapse_segment_grow_update()
RETURNS TRIGGER
AS $$
DECLARE
  permanence CONSTANT NUMERIC :=
    htm.config('synapse_distal_threshold')::NUMERIC +
    htm.config('synapse_distal_increment')::NUMERIC;
  synapse_max CONSTANT INT := htm.config('synapse_distal_count');
  anchors INT[];
  openings INT[];
  recents INT[];
  segments INT[];
  segments_length INT;
BEGIN
  SELECT ARRAY(
    SELECT ca.id
    FROM htm.cell_anchor AS ca
    WHERE ca.segment_grow
  ) INTO anchors;

  SELECT ARRAY(
    SELECT c.id
    FROM htm.cell AS c
    WHERE c.active_last
  ) INTO recents;

  IF (
    (COALESCE(ARRAY_LENGTH(anchors, 1), 0) > 0) AND
    (COALESCE(ARRAY_LENGTH(recents, 1), 0) > 0)
  ) THEN
    PERFORM
      htm.debug('TM growing new segments/synapses on learning anchor cells');
    -- grow new segments
    segments := htm.segment_anchor_grow_updates(anchors);
    segments_length := COALESCE(ARRAY_LENGTH(segments, 1), 0);
    -- grow new synapses on new segments
    openings := ARRAY_FILL(synapse_max, ARRAY[segments_length]);
    PERFORM htm.synapse_distal_anchor_grow_updates(segments, openings, recents);
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

