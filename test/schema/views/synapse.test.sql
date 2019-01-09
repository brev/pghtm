/**
 * Synapse (Active) View Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(4);  -- Test count


-- test synapse_connected
SELECT has_view('synapse_connected');
SELECT has_column('synapse_connected', 'id');

-- test synapse_proximal_active
SELECT has_view('synapse_proximal_active');
SELECT has_column('synapse_proximal_active', 'id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

