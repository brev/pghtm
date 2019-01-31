/**
 * Segment Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM segment; $$,
  ROW((
    (
      config('cell_count')::INT *
      config('segment_count')::INT
    ) +
    config('column_count')::INT
  )::BIGINT),
  'Segment has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

