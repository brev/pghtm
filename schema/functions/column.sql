/**
 * Column Functions
 */


/**
 * Get inhibition global limit if turned on, otherwise off.
 *  Used to select winning active columns.
 */
CREATE FUNCTION htm.column_active_get_threshold()
RETURNS BIGINT 
AS $$
DECLARE
  threshold CONSTANT BIGINT := htm.const('column_threshold');
  inhibit CONSTANT INTEGER := htm.var('inhibition');
BEGIN
  CASE
    WHEN inhibit = 0
      -- inhibition off
      THEN RETURN NULL;
    WHEN inhibit = 1
      -- global inhibition on
      THEN RETURN threshold;
    WHEN inhibit = 2
      -- local inhibition on (TODO not built yet)
      THEN RETURN NULL;
  END CASE;
END;
$$ LANGUAGE plpgsql;

/**
 * Update column.duty_cycle_(active/overlap) based on changes to
 *  previous views (after new input).
 */
CREATE FUNCTION htm.column_boost_duty_update() 
RETURNS TRIGGER
AS $$
DECLARE
  period CONSTANT INTEGER := htm.duty_cycle_period();
BEGIN
  PERFORM htm.log('new input, updating column duty cycles, etc.');
  WITH column_next AS (
    SELECT 
      htm.column.id,
      htm.boost_factor_compute(
        htm.running_moving_average(
          htm.column.duty_cycle_active,
          (column_active.id IS NOT NULL)::INTEGER,
          htm.duty_cycle_period()
        ),
        region.duty_cycle_active_mean
      ) AS boost_factor,
      htm.running_moving_average(
        htm.column.duty_cycle_active,
        (column_active.id IS NOT NULL)::INTEGER,
        htm.duty_cycle_period()
      ) AS duty_cycle_active,
      htm.running_moving_average(
        htm.column.duty_cycle_overlap,
        (column_overlap_boost.overlap IS NOT NULL)::INTEGER,
        htm.duty_cycle_period()
      ) AS duty_cycle_overlap
    FROM htm.column
    JOIN htm.region
      ON region.id = htm.column.region_id
    LEFT JOIN htm.column_active
      ON column_active.id = htm.column.id
    LEFT JOIN htm.column_overlap_boost
      ON column_overlap_boost.id = htm.column.id
    GROUP BY
      htm.column.id,
      htm.column.duty_cycle_active,
      htm.column.duty_cycle_overlap,
      region.duty_cycle_active_mean,
      column_active.id,
      column_overlap_boost.id,
      column_overlap_boost.overlap
  )
  UPDATE htm.column
    SET 
      boost_factor = column_next.boost_factor,
      duty_cycle_active = column_next.duty_cycle_active,
      duty_cycle_overlap = column_next.duty_cycle_overlap
    FROM column_next
    WHERE column_next.id = htm.column.id;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

