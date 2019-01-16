/**
 * Region Functions
 */


/**
 * Update region.duty_cycle_active/overlap_mean based on changes to
 *  column.duty_cycle_* previously (cascading down from new input).
 *  TODO maybe try "AVG ( DISTINCT htm.column.duty_cycle_ )" sometime instead.
 */
CREATE FUNCTION htm.region_duty_cycles_update() 
RETURNS TRIGGER
AS $$
BEGIN
  PERFORM htm.log('region updating overall duty cycle mean averages');
  WITH region_next AS (
    SELECT 
      htm.column.region_id AS id,
      AVG(htm.column.duty_cycle_active) AS duty_cycle_active_mean,
      AVG(htm.column.duty_cycle_overlap) AS duty_cycle_overlap_mean
    FROM htm.column
    GROUP BY htm.column.region_id
  )
  UPDATE htm.region
    SET 
      duty_cycle_active_mean = region_next.duty_cycle_active_mean,
      duty_cycle_overlap_mean = region_next.duty_cycle_overlap_mean
    FROM region_next
    WHERE region_next.id = region.id;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

