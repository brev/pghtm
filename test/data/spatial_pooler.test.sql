/**
 * Spatial Pooler Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(10);  -- Test count


SELECT is(
  sp_get('unit_test_data'), 
  555::VARCHAR, 
  'sp_get() seems to work'
);
SELECT is(
  sp_set('unit_test_data', 444::VARCHAR), 
  TRUE, 
  'sp_set() seemed to work'
);
SELECT is(
  sp_get('unit_test_data'), 
  444::VARCHAR, 
  'sp_set() confirmed to be working'
);

SELECT is(
  array_length(sp_column_active(ARRAY[0,1,2]), 1),
  config('ThresholdColumn')::INTEGER,
  'sp_column_active() seems to be working'
);

SELECT row_eq($$
  SELECT COUNT(id) > 0
    FROM synapse
    WHERE permanence < (
      config('SynapseThreshold')::NUMERIC - config('SynapseDecrement')::NUMERIC
    )
    OR permanence > (
      config('SynapseThreshold')::NUMERIC + config('SynapseIncrement')::NUMERIC
    );
  $$,
  ROW(FALSE::BOOLEAN),
  'Synapse permanences are pristine (in small random range around threshold)'
);
SELECT is(
  pg_typeof(sp_learn(ARRAY[0,1,2])),
  'boolean',
  'sp_learn() seems to work during learning test'
);
SELECT row_eq($$
  SELECT COUNT(id) > 0
    FROM synapse
    WHERE permanence < (
      config('SynapseThreshold')::NUMERIC - config('SynapseDecrement')::NUMERIC
    )
    OR permanence > (
      config('SynapseThreshold')::NUMERIC + config('SynapseIncrement')::NUMERIC
    );
  $$,
  ROW(TRUE::BOOLEAN),
  'Synapse permanences are changed during learning'
);

SELECT is(
  sp_get('compute_iterations'), 
  0::VARCHAR, 
  'Spatial Pooler starts with valid compute_iterations data'
);
SELECT is(
  array_length(sp_compute(ARRAY[0,1,2]), 1),
  config('ThresholdColumn')::INTEGER,
  'sp_compute() works during compute_iterations increment test'
);
SELECT is(
  sp_get('compute_iterations'), 
  1::VARCHAR, 
  'Spatial Pooler ends with valid compute_iterations data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

