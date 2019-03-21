/**
 * Config Trigger Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


SELECT has_trigger('config', 'trigger_config_regenerate_change');
SELECT has_trigger('config', 'trigger_config_modified_change');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

