/**
 * Segment (Proximal: Overlap/Active) View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test segment_proximal_overlap_active
SELECT has_view('segment_proximal_overlap_active');
SELECT has_column('segment_proximal_overlap_active', 'id');
SELECT has_column('segment_proximal_overlap_active', 'overlap');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

