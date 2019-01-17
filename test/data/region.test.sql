/**
 * Region Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM region $$,
  ROW(1::BIGINT),
  'Region has valid data'
);

SELECT row_eq(
  $$
    SELECT
      AVG(duty_cycle_active_mean) <> 0.0,
      AVG(duty_cycle_overlap_mean) <> 0.0
    FROM region
  $$,
  ROW(FALSE, FALSE),
  'Region has valid active/overlap mean averages on init'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3,4]);
SELECT row_eq(
  $$
    SELECT
      AVG(duty_cycle_active_mean) <> 0.0,
      AVG(duty_cycle_overlap_mean) <> 0.0
    FROM region
  $$,
  ROW(TRUE, TRUE),
  'Region has valid active/overlap mean averages after data run'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

