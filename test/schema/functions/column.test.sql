/**
 * Input Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(6);  -- Test count


-- test htm.column_active_get_threshold()
SELECT has_function('column_active_get_threshold');
SELECT function_lang_is('column_active_get_threshold', 'plpgsql');
SELECT function_returns('column_active_get_threshold', 'bigint');
/*
 TODO test functionality here
*/

-- test column_boost_duty_update()
SELECT has_function('column_boost_duty_update');
SELECT function_lang_is('column_boost_duty_update', 'plpgsql');
SELECT function_returns('column_boost_duty_update', 'trigger');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

