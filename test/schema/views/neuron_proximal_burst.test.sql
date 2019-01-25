/**
 * Neuron (Proximal: Bursting) View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test neuron_proximal_burst
SELECT has_view('neuron_proximal_burst');
SELECT has_column('neuron_proximal_burst', 'id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

