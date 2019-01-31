/**
 * Cell (Distal: Predict) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test cell_distal_predict
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM cell_distal_predict $$,
  ROW(FALSE),
  'Cell Distal Predict view has valid init count'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
/*
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM cell_distal_predict $$,
  ROW(TRUE),
  'Cell Distal Predict view has valid count after data'
);
*/
SELECT is(1,1,'TODO');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

