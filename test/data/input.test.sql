/**
 * Input Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM input; $$, 
  ROW(0::BIGINT), 
  'Input has valid data on init'
);
INSERT 
  INTO htm.input (ts, indexes) 
  VALUES (NOW(), ARRAY[0, 1, 2]);
SELECT row_eq(
  $$ SELECT COUNT(id) FROM input; $$, 
  ROW(1::BIGINT), 
  'Input has valid data after input'
);
SELECT row_eq(
  $$ SELECT columns_active IS NOT NULL FROM input; $$, 
  ROW(TRUE), 
  'Input has valid data after spatial pooling computation'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data
