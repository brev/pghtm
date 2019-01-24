/**
 * Synapse (Distal: Connected) View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test synapse_distal_connected
SELECT has_view('synapse_distal_connected');
SELECT has_column('synapse_distal_connected', 'id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

