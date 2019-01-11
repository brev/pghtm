/**
 * Column Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT has_trigger('column', 'trigger_column_region_duty_cycles_change');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

