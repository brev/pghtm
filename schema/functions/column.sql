/**
 * Column Functions
 */


/**
 * Update column.overlap_duty_cycle based on changes to
 *  column_overlap view.
 */
CREATE FUNCTION htm.column_overlap_duty_cycle_update() 
RETURNS TRIGGER
AS $$
DECLARE
  period CONSTANT INTEGER := htm.duty_cycle_period();
BEGIN
  WITH column_next AS (
    SELECT 
      htm.column.id AS column_id,
      htm.running_moving_average(
        htm.column.overlap_duty_cycle,
        (column_overlap.overlap IS NOT NULL)::INTEGER,
        period
      ) AS new_overlap_duty_cycle
    FROM htm.column
    LEFT JOIN htm.column_overlap
      ON column_overlap.id = htm.column.id
  )
  UPDATE htm.column
    SET overlap_duty_cycle = column_next.new_overlap_duty_cycle
    FROM column_next
    WHERE htm.column.id = column_next.column_id;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

