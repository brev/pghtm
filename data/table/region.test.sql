/**
 * Region Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(4);  -- Test count


-- test region count
SELECT row_eq(
  $$
    SELECT COUNT(r.id)
    FROM region AS r
  $$,
  ROW(1::BIGINT),
  'Region has valid data'
);

-- test region SP calcs
SELECT row_eq(
  $$
    SELECT
      AVG(r.duty_cycle_active_mean) <> 0.0,
      AVG(r.duty_cycle_overlap_mean) <> 0.0
    FROM region AS r
  $$,
  ROW(FALSE, FALSE),
  'Region has valid active/overlap mean averages on init'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3,4]);
SELECT row_eq(
  $$
    SELECT
      AVG(r.duty_cycle_active_mean) <> 0.0,
      AVG(r.duty_cycle_overlap_mean) <> 0.0
    FROM region AS r
  $$,
  ROW(FALSE, TRUE),
  'Region has valid active/overlap mean averages after input #1'
);
INSERT INTO input (indexes) VALUES (ARRAY[1,2,3,4,5]);
SELECT row_eq(
  $$
    SELECT
      AVG(r.duty_cycle_active_mean) <> 0.0,
      AVG(r.duty_cycle_overlap_mean) <> 0.0
    FROM region AS r
  $$,
  ROW(TRUE, TRUE),
  'Region has valid active/overlap mean averages after input #2'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

