/**
 * Segment (Distal: Learning "Anchor") View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(4);  -- Test count


-- test segment_distal_anchor
SELECT has_view('segment_distal_anchor');
SELECT has_column('segment_distal_anchor', 'id');
SELECT has_column('segment_distal_anchor', 'synapse_count');
SELECT has_column('segment_distal_anchor', 'order_id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

