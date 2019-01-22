/**
 * Config Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT has_trigger('config', 'trigger_config_regenerate_change');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

