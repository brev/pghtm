/**
 * Input Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


SELECT has_trigger('input', 'trigger_input_modified_change');
SELECT has_trigger('input', 'trigger_input_sp_iteration_change');
SELECT has_trigger('input', 'trigger_input_synapse_active_change');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

