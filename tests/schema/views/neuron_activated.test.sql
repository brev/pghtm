/**
 * Neuron (Activated) View Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(4);  -- Test count


SELECT has_view('neuron_activated');

SELECT has_column('neuron_activated', 'id');
SELECT has_column('neuron_activated', 'column_id');
SELECT has_column('neuron_activated', 'y_coord');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

