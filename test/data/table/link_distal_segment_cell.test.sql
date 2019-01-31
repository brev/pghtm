/**
 * Link (Distal) Segment to Cell Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM link_distal_segment_cell; $$,
  ROW(0::BIGINT),
  'Link_Distal_Segment_Cell has valid init data (none)'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

