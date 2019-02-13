/**
 * Segment (Distal: Active) View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test segment_active
SELECT has_view('segment_active');
SELECT has_column('segment_active', 'id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

