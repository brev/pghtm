/**
 * Column (Active) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM column_active $$,
  ROW(FALSE),
  'Column Active view has valid init count'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3,4]);
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM column_active $$,
  ROW(TRUE),
  'Column Active view has valid data count'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

