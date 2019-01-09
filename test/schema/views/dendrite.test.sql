/**
 * Dendrite View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test dendrite_proximal_active_overlap
SELECT has_view('dendrite_proximal_active_overlap');
SELECT has_column('dendrite_proximal_active_overlap', 'id');
SELECT has_column('dendrite_proximal_active_overlap', 'overlap');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

