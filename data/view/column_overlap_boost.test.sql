/**
 * Column (Overlap/Boosting) View Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM column_overlap_boost $$,
  ROW(FALSE),
  'Column Overlap/Boost view has valid init count'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3,4]);
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM column_overlap_boost $$,
  ROW(TRUE),
  'Column Overlap/Boost view has valid data count'
);
SELECT row_eq(
  $$ SELECT (MIN(overlap) > 0) FROM column_overlap_boost $$,
  ROW(TRUE),
  'Column Overlap/Boost view has valid overlap counts'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

