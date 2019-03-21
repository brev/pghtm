/**
 * Segment Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test segment growth
SELECT row_eq(
  $$
    SELECT (COUNT(s.id) > 0)
    FROM segment AS s
  $$,
  ROW(FALSE),
  'Segment has valid data on init'
);
INSERT INTO htm.input (indexes) VALUES (ARRAY[0,1,2,3]);
INSERT INTO htm.input (indexes) VALUES (ARRAY[10,11,12,13]);
INSERT INTO htm.input (indexes) VALUES (ARRAY[20,21,22,23]);
INSERT INTO htm.input (indexes) VALUES (ARRAY[0,1,2,3]);
INSERT INTO htm.input (indexes) VALUES (ARRAY[10,11,12,13]);
SELECT row_eq(
  $$
    SELECT (COUNT(s.id) > 0)
    FROM segment AS s
  $$,
  ROW(TRUE),
  'Segment has valid data after TM input'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

