/**
 * Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT value FROM synapse WHERE key = 'compute_iterations'; $$, 
  ROW(0::varchar),  
  'Spatial Pooler has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

