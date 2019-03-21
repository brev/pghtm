/**
 * Synapse (Proximal) Function Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(18);  -- Test count


-- test synapse_proximal_boost_update()
SELECT has_function('synapse_proximal_boost_update');
SELECT function_lang_is('synapse_proximal_boost_update', 'plpgsql');
SELECT function_returns('synapse_proximal_boost_update', 'trigger');

-- test synapse_proximal_get_connection()
SELECT has_function('synapse_proximal_get_connection', ARRAY['numeric']);
SELECT function_lang_is('synapse_proximal_get_connection', 'plpgsql');
SELECT volatility_is('synapse_proximal_get_connection', 'stable');
SELECT function_returns('synapse_proximal_get_connection', 'boolean');

-- test synapse_proximal_get_decrement()
SELECT has_function('synapse_proximal_get_decrement', ARRAY['numeric']);
SELECT function_lang_is('synapse_proximal_get_decrement', 'plpgsql');
SELECT volatility_is('synapse_proximal_get_decrement', 'stable');
SELECT function_returns('synapse_proximal_get_decrement', 'numeric');

-- test synapse_proximal_get_increment()
SELECT has_function('synapse_proximal_get_increment', ARRAY['numeric']);
SELECT function_lang_is('synapse_proximal_get_increment', 'plpgsql');
SELECT volatility_is('synapse_proximal_get_increment', 'stable');
SELECT function_returns('synapse_proximal_get_increment', 'numeric');

-- test synapse_proximal_learn_update()
SELECT has_function('synapse_proximal_learn_update');
SELECT function_lang_is('synapse_proximal_learn_update', 'plpgsql');
SELECT function_returns('synapse_proximal_learn_update', 'trigger');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

