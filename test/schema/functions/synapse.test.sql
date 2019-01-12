/**
 * Synapse Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(24);  -- Test count


-- test synapse_is_connected()
SELECT has_function('synapse_is_connected', ARRAY['numeric']);
SELECT function_lang_is('synapse_is_connected', 'plpgsql');
SELECT function_returns('synapse_is_connected', 'boolean');
SELECT is(synapse_is_connected(0.00), false, 'synapse_is_connected() works min');
SELECT is(
  synapse_is_connected(
    config('SynapseThreshold')::NUMERIC - 
    config('SynapseDecrement')::NUMERIC
  ), 
  false,
  'synapse_is_connected() false under threshold'
);
SELECT is(
  synapse_is_connected(config('SynapseThreshold')::NUMERIC), 
  false,
  'synapse_is_connected() false on threshold'
);
SELECT is(
  synapse_is_connected(
    config('SynapseThreshold')::NUMERIC + 
    config('SynapseIncrement')::NUMERIC
  ), 
  true,
  'synapse_is_connected() true beyond threshold'
);
SELECT is(synapse_is_connected(1.00), true, 'synapse_is_connected() works max');

-- test synapse_permanence_decrement()
SELECT has_function('synapse_permanence_decrement', ARRAY['numeric']);
SELECT function_lang_is('synapse_permanence_decrement', 'plpgsql');
SELECT function_returns('synapse_permanence_decrement', 'numeric');
SELECT is(
  synapse_permanence_decrement(0.00001), 
  0.0, 
  'synapse_permanence_decrement() unlearns down to min 0.0'
);
SELECT cmp_ok(
  synapse_permanence_decrement(0.11), 
  '<', 
  0.11, 
  'synapse_permanence_decrement() unlearns down below threshold'
);

-- test synapse_permanence_increment()
SELECT has_function('synapse_permanence_increment', ARRAY['numeric']);
SELECT function_lang_is('synapse_permanence_increment', 'plpgsql');
SELECT function_returns('synapse_permanence_increment', 'numeric');
SELECT cmp_ok(
  synapse_permanence_increment(0.88), 
  '>', 
  0.88, 
  'synapse_permanence_increment() learns up above threshold'
);
SELECT is(
  synapse_permanence_increment(0.99999), 
  1.0, 
  'synapse_permanence_increment() learns up to max 1.0'
);

-- test synapse_permanence_boost_update()
SELECT has_function('synapse_permanence_boost_update');
SELECT function_lang_is('synapse_permanence_boost_update', 'plpgsql');
SELECT function_returns('synapse_permanence_boost_update', 'trigger');

-- test synapse_permanence_learn_update()
SELECT has_function('synapse_permanence_learn_update');
SELECT function_lang_is('synapse_permanence_learn_update', 'plpgsql');
SELECT function_returns('synapse_permanence_learn_update', 'trigger');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

