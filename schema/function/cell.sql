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
      SELECT DISTINCT(column_id) AS id
      FROM htm.cell_distal_predict
    )
    SELECT
      cell.id,
      (CASE
        WHEN (COUNT(cell_distal_predict.id) > 0) THEN
          TRUE  -- predicted => active
        WHEN (
          (column_predict.id IS NULL) AND
          (COUNT(cell_proximal_burst.id) > 0)
        ) THEN
          TRUE  -- bursting => active
        ELSE
          FALSE  -- not predict, not burst, nor bursting with predicted column
      END) AS active
    FROM htm.cell
    LEFT JOIN column_predict
      ON column_predict.id = cell.column_id
    LEFT JOIN htm.cell_distal_predict
      ON cell_distal_predict.id = cell.id
    LEFT JOIN htm.cell_proximal_burst
      ON cell_proximal_burst.id = cell.id
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

