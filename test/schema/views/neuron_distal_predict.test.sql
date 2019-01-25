/**
 * Neuron (Distal: Predict) View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test neuron_distal_predict
SELECT has_view('neuron_distal_predict');
SELECT has_column('neuron_distal_predict', 'id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

