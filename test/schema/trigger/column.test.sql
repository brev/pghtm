/**
 * Column Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(6);  -- Test count


SELECT has_trigger('column', 'trigger_column_active_change');
SELECT has_trigger('column', 'trigger_column_input_columns_active_change');
SELECT has_trigger('column', 'trigger_column_modified_change');
SELECT has_trigger('column', 'trigger_column_region_duty_cycles_change');
SELECT has_trigger('column', 'trigger_column_synapse_permanence_boost_change');
SELECT has_trigger(
  'column',
  'trigger_column_synapse_proximal_permanence_learn_change'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

