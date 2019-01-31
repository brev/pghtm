/**
 * Segment Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM segment; $$,
  ROW((config('column_count')::INT)::BIGINT),
  'Segment (proximal) has valid init data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

