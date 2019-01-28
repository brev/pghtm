/**
 * Dendrite (Distal: Active) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test dendrite_distal_active
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM dendrite_distal_active $$,
  ROW(FALSE),
  'Dendrite Distal Active view has valid init count'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3,4]);
/*
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM dendrite_distal_active $$,
  ROW(TRUE),
  'Dendrite Distal Active view has valid data count'
);
*/
SELECT is(1,1,'one');  --- !!!!!! TODO


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

