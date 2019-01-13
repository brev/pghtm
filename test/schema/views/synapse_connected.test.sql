/**
 * Synapse (Connected) View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test synapse_connected
SELECT has_view('synapse_connected');
SELECT has_column('synapse_connected', 'id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

