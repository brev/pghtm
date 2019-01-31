/**
 * Segment (Proximal: Overlap/Active) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test segment_proximal_overlap_active
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM segment_proximal_overlap_active $$,
  ROW(FALSE),
  'Segment Proximal Overlap/Active view has valid init count'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3,4]);
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM segment_proximal_overlap_active $$,
  ROW(TRUE),
  'Segment Proximal Overlap/Active view has valid data count'
);
SELECT row_eq(
  $$ SELECT (MIN(overlap) > 0) FROM segment_proximal_overlap_active $$,
  ROW(TRUE),
  'Segment Proximal Overlap/Active view has valid overlap counts'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

