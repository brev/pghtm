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
 * Update column.active based on recent changes to column.(duty cycles, etc).
 * @SpatialPooler
 */
CREATE FUNCTION htm.column_active_update()
RETURNS TRIGGER
AS $$
BEGIN
  PERFORM htm.debug('SP updating winner column activity state');
  WITH column_next AS (
    SELECT
      c.id,
      (
        htm.column_active_get_limit() >= (
          ROW_NUMBER() OVER(
            ORDER BY cob.overlap_boosted DESC NULLS LAST
          )
        )
      ) AS active  -- global column inhibition
    FROM htm.column AS c
    LEFT JOIN htm.column_overlap_boost AS cob
      ON cob.id = c.id
    ORDER BY cob.overlap_boosted DESC NULLS LAST
  )
  UPDATE htm.column AS c
    SET active = cn.active
    FROM column_next AS cn
    WHERE cn.id = c.id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

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
  PERFORM htm.debug('SP has new input so updating column boosting/duty_cycles');
  WITH column_next AS (
    SELECT
      c.id,
      htm.column_boost_factor_compute(
        htm.running_moving_average(
          c.duty_cycle_active,
          c.active::INT,
          period
        ),
        r.duty_cycle_active_mean
      ) AS boost_factor,
      htm.running_moving_average(
        c.duty_cycle_active,
        c.active::INT,
        period
      ) AS duty_cycle_active,
      htm.running_moving_average(
        c.duty_cycle_overlap,
        (cob.overlap IS NOT NULL)::INT,
        period
      ) AS duty_cycle_overlap
    FROM htm.column AS c
    JOIN htm.region AS r
      ON r.id = c.region_id
    LEFT JOIN htm.column_overlap_boost AS cob
      ON cob.id = c.id
    GROUP BY
      c.id,
      c.duty_cycle_active,
      c.duty_cycle_overlap,
      r.duty_cycle_active_mean,
      cob.id,
      cob.overlap
  )
  UPDATE htm.column AS c
    SET
      boost_factor = cn.boost_factor,
      duty_cycle_active = cn.duty_cycle_active,
      duty_cycle_overlap = cn.duty_cycle_overlap
    FROM column_next AS cn
    WHERE cn.id = c.id;

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

/**
 * Check if a column is active (# active proximal syanpses above threshold).
 * @SpatialPooler
 */
CREATE FUNCTION htm.column_is_active(synapse_proximal_active INT)
RETURNS BOOL
AS $$
DECLARE
  threshold CONSTANT INT := htm.config('column_synapse_threshold');
BEGIN
  RETURN synapse_proximal_active > threshold;
END;
$$ LANGUAGE plpgsql STABLE;

