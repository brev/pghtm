/**
 * Segment (Distal: Active) View Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test segment_active
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM segment_active $$,
  ROW(FALSE),
  'Segment Distal Active view has valid init count'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
INSERT INTO input (indexes) VALUES (ARRAY[10,11,12,13]);
INSERT INTO input (indexes) VALUES (ARRAY[20,21,22,23]);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
INSERT INTO input (indexes) VALUES (ARRAY[10,11,12,13]);
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM segment_active $$,
  ROW(TRUE),
  'Segment Distal Active view has valid data count'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

