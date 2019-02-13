/**
 * Cell (Distal: Predict) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test cell_predict
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM cell_predict $$,
  ROW(FALSE),
  'Cell Distal Predict view has valid init count'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
INSERT INTO input (indexes) VALUES (ARRAY[10,11,12,13]);
INSERT INTO input (indexes) VALUES (ARRAY[20,21,22,23]);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
INSERT INTO input (indexes) VALUES (ARRAY[10,11,12,13]);
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM cell_predict $$,
  ROW(TRUE),
  'Cell Distal Predict view has valid count after data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

