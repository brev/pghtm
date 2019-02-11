/**
 * Column Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(5);  -- Test count


-- test column count
SELECT row_eq(
  $$ SELECT COUNT(id) FROM htm.column; $$,
  ROW(config('column_count')::BIGINT),
  'Column has valid data'
);

-- test column_duty_cycle_period() before data
SELECT is(
  column_duty_cycle_period(),
  0,
  'column_duty_cycle_period() works before input data rows'
);

-- test column fields
SELECT row_eq(
  $$
    SELECT
      AVG(boost_factor) <> 0.0,
      AVG(duty_cycle_active) <> 1.0,
      AVG(duty_cycle_overlap) <> 1.0,
      SUM(active::INT) <> 0
    FROM htm.column
  $$,
  ROW(FALSE, FALSE, FALSE, FALSE),
  'Column has valid activity, boost, and duty cycles on init'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3,4]);
SELECT row_eq(
  $$
    SELECT
      AVG(boost_factor) <> 0.0,
      AVG(duty_cycle_active) <> 1.0,
      AVG(duty_cycle_overlap) <> 1.0,
      SUM(active::INT) <> 0
    FROM htm.column
  $$,
  ROW(TRUE, TRUE, TRUE, TRUE),
  'Column has valid activity, boost, and duty cycles after input'
);

-- test column_duty_cycle_period() after data
SELECT is(
  column_duty_cycle_period(),
  1,
  'column_duty_cycle_period() works after input data rows'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

