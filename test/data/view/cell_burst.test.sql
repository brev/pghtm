/**
 * Cell (Proximal: Burst) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test cell_burst
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM cell_burst $$,
  ROW(FALSE),
  'Cell Proximal Burst view has valid init count'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM cell_burst $$,
  ROW(TRUE),
  'Cell Proximal Burst view has valid count after data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data
