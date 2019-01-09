/**
 * Input Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT has_trigger('input', 'trigger_input_modified_change');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

