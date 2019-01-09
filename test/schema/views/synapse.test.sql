/**
 * Synapse (Active) View Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(6);  -- Test count


SELECT has_view('synapse_active');
SELECT has_column('synapse_active', 'id');
SELECT has_column('synapse_active', 'active');

SELECT has_view('synapse_connected');
SELECT has_column('synapse_connected', 'id');
SELECT has_column('synapse_connected', 'connected');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

