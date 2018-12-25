/**
 * Region Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM region; $$, 
  ROW(1::BIGINT), 
  'Region has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

