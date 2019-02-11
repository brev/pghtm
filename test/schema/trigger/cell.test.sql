/**
 * Cell Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(5);  -- Test count


SELECT has_trigger('cell', 'trigger_cell_active_last_change');
SELECT has_trigger('cell', 'trigger_cell_anchor_synapse_learn_change');
SELECT has_trigger('cell', 'trigger_cell_anchor_synapse_segment_grow_change');
SELECT has_trigger('cell', 'trigger_cell_input_columns_predict_change');
SELECT has_trigger('cell', 'trigger_cell_modified_change');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

