/**
 * Input Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


INSERT 
  INTO htm.input (id, indexes) 
  VALUES (NOW(), ARRAY[0, 1, 2]);
SELECT row_eq(
  $$ SELECT COUNT(id) FROM input; $$, 
  ROW(1::BIGINT), 
  'Input has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data
