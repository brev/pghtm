/**
 * Column Function Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(22);  -- Test count


-- test column_active_get_limit()
SELECT has_function('column_active_get_limit');
SELECT function_lang_is('column_active_get_limit', 'plpgsql');
SELECT volatility_is('column_active_get_limit', 'stable');
SELECT function_returns('column_active_get_limit', 'bigint');

-- test column_active_update()
SELECT has_function('column_active_update');
SELECT function_lang_is('column_active_update', 'plpgsql');
SELECT function_returns('column_active_update', 'trigger');

-- test column_boost_duty_update()
SELECT has_function('column_boost_duty_update');
SELECT function_lang_is('column_boost_duty_update', 'plpgsql');
SELECT function_returns('column_boost_duty_update', 'trigger');

-- test column_boost_factor_compute()
SELECT has_function('column_boost_factor_compute');
SELECT function_lang_is('column_boost_factor_compute', 'plpgsql');
SELECT volatility_is('column_boost_factor_compute', 'stable');
SELECT function_returns('column_boost_factor_compute', 'numeric');

-- test column_duty_cycle_period()
SELECT has_function('column_duty_cycle_period');
SELECT function_lang_is('column_duty_cycle_period', 'plpgsql');
SELECT volatility_is('column_duty_cycle_period', 'stable');
SELECT function_returns('column_duty_cycle_period', 'integer');

-- test column_is_active()
SELECT has_function('column_is_active', ARRAY['integer']);
SELECT function_lang_is('column_is_active', 'plpgsql');
SELECT volatility_is('column_is_active', 'stable');
SELECT function_returns('column_is_active', 'boolean');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

