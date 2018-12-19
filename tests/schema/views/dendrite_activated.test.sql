/**
 * Dendrites (Activated) View Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


SELECT has_view('dendrite_activated');

SELECT has_column('dendrite_activated', 'id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

