/**
 * Column Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM htm.column; $$, 
  ROW(config('ColumnCount')::BIGINT), 
  'Column has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

