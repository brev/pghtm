/**
 * Input Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT has_trigger('input', 'update_modified_input');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

