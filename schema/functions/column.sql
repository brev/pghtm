/**
 * Column Functions
 */


/**
 * Update column.duty_cycle_(active/overlap) based on changes to
 *  previous views (after new input).
 */
CREATE FUNCTION htm.column_duty_cycles_update() 
RETURNS TRIGGER
AS $$
DECLARE
  period CONSTANT INTEGER := htm.duty_cycle_period();
BEGIN
  WITH column_next AS (
    SELECT 
      htm.column.id AS column_id,
      htm.running_moving_average(
        htm.column.duty_cycle_active,
        (column_active.id IS NOT NULL)::INTEGER,
        period
      ) AS new_duty_cycle_active,
      htm.running_moving_average(
        htm.column.duty_cycle_overlap,
        (column_overlap.overlap IS NOT NULL)::INTEGER,
        period
      ) AS new_duty_cycle_overlap
    FROM htm.column
    LEFT JOIN htm.column_active
      ON column_active.id = htm.column.id
    LEFT JOIN htm.column_overlap
      ON column_overlap.id = htm.column.id
  )
  UPDATE htm.column
    SET 
      duty_cycle_active = column_next.new_duty_cycle_active,
      duty_cycle_overlap = column_next.new_duty_cycle_overlap
    FROM column_next
    WHERE htm.column.id = column_next.column_id;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

