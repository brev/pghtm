/**
 * Column Function Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(9);  -- Test count


-- test column_active_get_limit()
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

-- test column_boost_factor_compute()
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
SELECT is(
  column_duty_cycle_period(),
  0,
  'column_duty_cycle_period() works before input data rows'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3,4]);
SELECT is(
  column_duty_cycle_period(),
  1,
  'column_duty_cycle_period() works after input data rows'
);

-- test column_is_active()
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

