/**
 * Link Segment to Cell Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM link_distal_segment_cell; $$,
  ROW((
    config('cell_count')::INT *
    config('segment_count')::INT
  )::BIGINT),
  'Link_Segment_Cell has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

