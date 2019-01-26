/**
 * Dendrite (Distal: Active) View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test dendrite_distal_active
SELECT has_view('dendrite_distal_active');
SELECT has_column('dendrite_distal_active', 'id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

