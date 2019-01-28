/**
 * Neuron (Distal: Predict) View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test neuron_distal_predict
SELECT has_view('neuron_distal_predict');
SELECT has_column('neuron_distal_predict', 'id');
SELECT has_column('neuron_distal_predict', 'column_id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

