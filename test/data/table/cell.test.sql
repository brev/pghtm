/**
 * Cell Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM cell; $$,
  ROW(config('cell_count')::BIGINT),
  'Cell has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

