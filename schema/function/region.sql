/**
 * Region Functions
 */


/**
 * Update region.duty_cycle_active/overlap_mean based on changes to
 *  column.duty_cycle_* previously (cascading down from new input).
 *  TODO maybe try "AVG ( DISTINCT htm.column.duty_cycle_ )" sometime instead.
 * @SpatialPooler
 */
CREATE FUNCTION htm.region_duty_cycles_update()
RETURNS TRIGGER
AS $$
BEGIN
  PERFORM htm.debug('SP region updating overall duty cycle mean averages');
  WITH region_next AS (
    SELECT
      c.region_id AS id,
      AVG(c.duty_cycle_active) AS duty_cycle_active_mean,
      AVG(c.duty_cycle_overlap) AS duty_cycle_overlap_mean
    FROM htm.column AS c
    GROUP BY c.region_id
  )
  UPDATE htm.region AS r
    SET
      duty_cycle_active_mean = rn.duty_cycle_active_mean,
      duty_cycle_overlap_mean = rn.duty_cycle_overlap_mean
    FROM region_next AS rn
    WHERE rn.id = r.id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

