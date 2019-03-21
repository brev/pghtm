/**
 * Column Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test column count
SELECT row_eq(
  $$
    SELECT COUNT(c.id)
    FROM htm.column AS c
  $$,
  ROW(config('column_count')::BIGINT),
  'Column has valid data'
);

-- test column fields
SELECT row_eq(
  $$
    SELECT
      AVG(c.boost_factor) <> 0.0,
      AVG(c.duty_cycle_active) <> 1.0,
      AVG(c.duty_cycle_overlap) <> 1.0,
      SUM(c.active::INT) <> 0
    FROM htm.column AS c
  $$,
  ROW(FALSE, FALSE, FALSE, FALSE),
  'Column has valid activity, boost, and duty cycles on init'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3,4]);
SELECT row_eq(
  $$
    SELECT
      AVG(c.boost_factor) <> 0.0,
      AVG(c.duty_cycle_active) <> 1.0,
      AVG(c.duty_cycle_overlap) <> 1.0,
      SUM(c.active::INT) <> 0
    FROM htm.column AS c
  $$,
  ROW(TRUE, TRUE, TRUE, TRUE),
  'Column has valid activity, boost, and duty cycles after input'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

