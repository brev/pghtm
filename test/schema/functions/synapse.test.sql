/**
 * Synapse Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(24);  -- Test count


-- test synapse_connected()
SELECT has_function('synapse_connected', ARRAY['numeric']);
SELECT function_lang_is('synapse_connected', 'plpgsql');
SELECT function_returns('synapse_connected', 'boolean');
SELECT is(synapse_connected(0.00), false, 'synapse_connected() works min');
SELECT is(
  synapse_connected(
    config('SynapseThreshold')::NUMERIC - 
    config('SynapseDecrement')::NUMERIC
  ), 
  false,
  'synapse_connected() false under threshold'
);
SELECT is(
  synapse_connected(config('SynapseThreshold')::NUMERIC), 
  false,
  'synapse_connected() false on threshold'
);
SELECT is(
  synapse_connected(
    config('SynapseThreshold')::NUMERIC + 
    config('SynapseIncrement')::NUMERIC
  ), 
  true,
  'synapse_connected() true beyond threshold'
);
SELECT is(synapse_connected(1.00), true, 'synapse_connected() works max');

-- test synapse_active_update()
SELECT has_function('synapse_active_update');
SELECT function_lang_is('synapse_active_update', 'plpgsql');
SELECT function_returns('synapse_active_update', 'trigger');

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

-- test synapse_connected_update()
SELECT has_function('synapse_connected_update');
SELECT function_lang_is('synapse_connected_update', 'plpgsql');
SELECT function_returns('synapse_connected_update', 'trigger');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

