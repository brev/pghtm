/**
 * Spatial Pooler Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(6);  -- Test count


SELECT row_eq(
  $$ SELECT value FROM spatial_pooler WHERE key = 'compute_iterations'; $$,
  ROW(0::VARCHAR),
  'Spatial Pooler starts with valid compute_iterations data'
);
SELECT is(
  pg_typeof(sp_compute(ARRAY[0,1,2])), 
  'integer[]', 
  'sp_compute() works'
);
SELECT row_eq(
  $$ SELECT value FROM spatial_pooler WHERE key = 'compute_iterations'; $$,
  ROW(1::VARCHAR),
  'Spatial Pooler ends with valid compute_iterations data'
);

SELECT is(
  sp_get('unit_test_data'), 
  555::VARCHAR, 
  'sp_get() works'
);
SELECT is(
  sp_set('unit_test_data', 444::VARCHAR), 
  TRUE, 
  'sp_set() seemed to work'
);
SELECT is(
  sp_get('unit_test_data'), 
  444::VARCHAR, 
  'sp_set() confirmed working'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

