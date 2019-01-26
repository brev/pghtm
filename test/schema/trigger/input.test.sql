/**
 * Input Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


SELECT has_trigger('input', 'trigger_input_column_boost_duty_change');
SELECT has_trigger('input', 'trigger_input_modified_change');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

