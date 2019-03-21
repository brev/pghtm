/**
 * Synapse (Distal: Connected) View Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test synapse_distal_connect
SELECT has_view('synapse_distal_connect');
SELECT has_column('synapse_distal_connect', 'id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

