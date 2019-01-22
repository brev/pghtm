/**
 * Column Functions
 */


/**
 * Get column global inhibition level (if turned on), otherwise null/none.
 *  Used to sparsify the set of winning active columns.
 * @SpatialPooler
 */
CREATE FUNCTION htm.column_active_get_limit()
RETURNS BIGINT
AS $$
DECLARE
  inhibit CONSTANT BOOL := htm.config('column_inhibit');
  limit CONSTANT BIGINT := htm.config('column_active_limit');
BEGIN
  IF inhibit THEN
    RETURN limit;   -- column global inhibition on
  ELSE
    RETURN NULL;  -- column global inhibition off
  END IF;
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Update column.duty_cycle_(active/overlap) based on changes to
 *  previous views (after new input).
 * @SpatialPooler
 */
CREATE FUNCTION htm.column_boost_duty_update()
RETURNS TRIGGER
AS $$
DECLARE
  period CONSTANT INT := htm.column_duty_cycle_period();
BEGIN
  PERFORM htm.debug('new input, updating column duty cycles, etc.');
  WITH column_next AS (
    SELECT
      htm.column.id,
      htm.column_boost_factor_compute(
        htm.running_moving_average(
          htm.column.duty_cycle_active,
          (column_active.id IS NOT NULL)::INT,
          period
        ),
        region.duty_cycle_active_mean
      ) AS boost_factor,
      htm.running_moving_average(
        htm.column.duty_cycle_active,
        (column_active.id IS NOT NULL)::INT,
        period
      ) AS duty_cycle_active,
      htm.running_moving_average(
        htm.column.duty_cycle_overlap,
        (column_overlap_boost.overlap IS NOT NULL)::INT,
        period
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

/**
 * Calculate new column boosting factor.
 * @SpatialPooler
 */
CREATE FUNCTION htm.column_boost_factor_compute(
  duty_cycle NUMERIC,
  target_density NUMERIC
)
RETURNS NUMERIC
AS $$
DECLARE
  learning CONSTANT BOOL := htm.config('synapse_proximal_learn');
  strength CONSTANT NUMERIC := htm.config('column_boost_strength');
BEGIN
  IF learning THEN
    RETURN EXP((0 - strength) * (duty_cycle - target_density));
  ELSE
    RETURN 1;  -- learning off
  END IF;
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Get ideal column duty cycle period value from several options.
 * @SpatialPooler
 */
CREATE FUNCTION htm.column_duty_cycle_period()
RETURNS INT
AS $$
DECLARE
  cool CONSTANT INT := htm.input_rows_count();
  warm CONSTANT INT := htm.config('column_duty_cycle_period');
BEGIN
  RETURN LEAST (cool, warm);
END;
$$ LANGUAGE plpgsql STABLE;

