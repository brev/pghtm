/**
 * Column Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(21);  -- Test count


-- test htm.column_active_get_limit()
SELECT has_function('column_active_get_limit');
SELECT function_lang_is('column_active_get_limit', 'plpgsql');
SELECT volatility_is('column_active_get_limit', 'stable');
SELECT function_returns('column_active_get_limit', 'bigint');
SELECT is(
  column_active_get_limit(),
  (CASE
    WHEN htm.config('column_inhibit')::INT = 0
      THEN NULL
    WHEN htm.config('column_inhibit')::INT = 1
      THEN htm.config('column_active_limit')::BIGINT
    WHEN htm.config('column_inhibit')::INT = 2
      THEN NULL
  END),
  'column_active_get_limit() works'
);

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
SELECT is(
  column_duty_cycle_period(),
  0,
  'column_duty_cycle_period() works before input data rows'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2]);
SELECT is(
  column_duty_cycle_period(),
  1,
  'column_duty_cycle_period() works after input data rows'
);
DELETE FROM input;


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

