/**
 * Input Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(4);  -- Test count


SELECT has_trigger('input', 'trigger_input_a_synapse_nonpredict_punish_change');
SELECT has_trigger('input', 'trigger_input_cell_active_change');
SELECT has_trigger('input', 'trigger_input_column_boost_duty_change');
SELECT has_trigger('input', 'trigger_input_modified_change');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

