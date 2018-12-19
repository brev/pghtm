/**
 * Synapse (Connected) View Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(4);  -- Test count


SELECT has_view('synapse_connected');

SELECT has_column('synapse_connected', 'id');
SELECT has_column('synapse_connected', 'dendrite_id');
SELECT has_column('synapse_connected', 'permanence');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

