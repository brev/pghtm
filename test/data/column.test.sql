/**
 * Column Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM htm.column; $$, 
  ROW(const('column_count')::BIGINT), 
  'Column has valid data'
);

SELECT row_eq(
  $$ 
    SELECT 
      AVG(boost_factor) <> 0.0, 
      AVG(duty_cycle_active) <> 1.0, 
      AVG(duty_cycle_overlap) <> 1.0 
    FROM htm.column
  $$,
  ROW(FALSE, FALSE, FALSE),
  'Column has valid init boost and duty cycles'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3,4]);
SELECT row_eq(
  $$ 
    SELECT 
      AVG(boost_factor) <> 0.0, 
      AVG(duty_cycle_active) <> 1.0, 
      AVG(duty_cycle_overlap) <> 1.0 
    FROM htm.column
  $$,
  ROW(TRUE, TRUE, TRUE),
  'Column has valid boost and duty cycles after data steps'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

