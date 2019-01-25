/**
 * Synapse (Proximal: Connected) View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test synapse_proximal_connect
SELECT has_view('synapse_proximal_connect');
SELECT has_column('synapse_proximal_connect', 'id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

