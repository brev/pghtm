/**
 * Region Functions
 */


/**
 * Update region.duty_cycle_active_(min/max) based on changes to
 *  column.duty_cycle_* previously (cascading down from new input).
 */
CREATE FUNCTION htm.region_duty_cycles_update() 
RETURNS TRIGGER
AS $$
BEGIN
  WITH region_next AS (
    SELECT 
      htm.column.region_id,
      MAX(htm.column.duty_cycle_active) AS new_duty_cycle_active_max,
      MIN(htm.column.duty_cycle_active) AS new_duty_cycle_active_min
    FROM htm.column
    GROUP BY htm.column.region_id
  )
  UPDATE htm.region
    SET 
      duty_cycle_active_max = region_next.new_duty_cycle_active_max,
      duty_cycle_active_min = region_next.new_duty_cycle_active_min
    FROM region_next
    WHERE region.id = region_next.region_id;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

