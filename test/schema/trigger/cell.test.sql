/**
 * Cell Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


SELECT has_trigger(
  'cell',
  'trigger_cell_synapse_distal_permanence_learn_change'
);
SELECT has_trigger('cell', 'trigger_cell_input_columns_predict_change');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

