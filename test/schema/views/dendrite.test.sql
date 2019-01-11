/**
 * Dendrite View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test dendrite_proximal_overlap_active
SELECT has_view('dendrite_proximal_overlap_active');
SELECT has_column('dendrite_proximal_overlap_active', 'id');
SELECT has_column('dendrite_proximal_overlap_active', 'overlap');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

