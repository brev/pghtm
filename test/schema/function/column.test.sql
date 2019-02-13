/**
 * Column Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(29);  -- Test count


-- test column_active_get_limit()
SELECT has_function('column_active_get_limit');
SELECT function_lang_is('column_active_get_limit', 'plpgsql');
SELECT volatility_is('column_active_get_limit', 'stable');
SELECT function_returns('column_active_get_limit', 'bigint');
SELECT is(
  column_active_get_limit(),
  (CASE
    WHEN htm.config('column_inhibit')::BOOL
      THEN htm.config('column_active_limit')::BIGINT
    ELSE
      NULL
  END),
  'column_active_get_limit() works'
);

-- test column_active_update()
SELECT has_function('column_active_update');
SELECT function_lang_is('column_active_update', 'plpgsql');
SELECT function_returns('column_active_update', 'trigger');

-- test column_boost_duty_update()
SELECT has_function('column_boost_duty_update');
SELECT function_lang_is('column_boost_duty_update', 'plpgsql');
SELECT function_returns('column_boost_duty_update', 'trigger');

-- test column_boost_factor_compute()
SELECT has_function('column_boost_factor_compute');
SELECT function_lang_is('column_boost_factor_compute', 'plpgsql');
SELECT volatility_is('column_boost_factor_compute', 'stable');
SELECT function_returns('column_boost_factor_compute', 'numeric');
SELECT is(
  column_boost_factor_compute(0.5, 0.5),
  (CASE
    WHEN htm.config('synapse_proximal_learn')::BOOL
      THEN EXP((0 - htm.config('column_boost_strength')::NUMERIC) * (0.5 - 0.5))
    ELSE 1
  END),
  'column_boost_factor_compute() works on equivalents'
);
SELECT is(
  column_boost_factor_compute(0.5, 1.0),
  (CASE
    WHEN htm.config('synapse_proximal_learn')::BOOL
      THEN EXP((0 - htm.config('column_boost_strength')::NUMERIC) * (0.5 - 1.0))
    ELSE 1
  END),
  'column_boost_factor_compute() works on low/high'
);
SELECT is(
  column_boost_factor_compute(1.0, 0.5),
  (CASE
    WHEN htm.config('synapse_proximal_learn')::BOOL
      THEN EXP((0 - htm.config('column_boost_strength')::NUMERIC) * (1.0 - 0.5))
    ELSE 1
  END),
  'column_boost_factor_compute() works on high/low'
);

-- test column_duty_cycle_period()
SELECT has_function('column_duty_cycle_period');
SELECT function_lang_is('column_duty_cycle_period', 'plpgsql');
SELECT volatility_is('column_duty_cycle_period', 'stable');
SELECT function_returns('column_duty_cycle_period', 'integer');

-- test column_is_active()
SELECT has_function('column_is_active', ARRAY['integer']);
SELECT function_lang_is('column_is_active', 'plpgsql');
SELECT volatility_is('column_is_active', 'stable');
SELECT function_returns('column_is_active', 'boolean');
SELECT is(column_is_active(0), FALSE, 'column_is_active() works min');
SELECT is(
  column_is_active(config('column_synapse_threshold')::INT),
  FALSE,
  'column_is_active() false on threshold'
);
SELECT is(
  column_is_active(config('column_synapse_threshold')::INT + 1),
  TRUE,
  'column_is_active() true beyond threshold'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

