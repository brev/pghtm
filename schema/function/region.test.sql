/**
 * Region Function Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test region_duty_cycles_update()
SELECT has_function('region_duty_cycles_update');
SELECT function_lang_is('region_duty_cycles_update', 'plpgsql');
SELECT function_returns('region_duty_cycles_update', 'trigger');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

