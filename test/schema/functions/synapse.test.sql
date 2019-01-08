/**
 * Synapse Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(36);  -- Test count


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

-- test synapse_permanence_learn()
SELECT has_function('synapse_permanence_learn', ARRAY['numeric']);
SELECT function_lang_is('synapse_permanence_learn', 'plpgsql');
SELECT function_returns('synapse_permanence_learn', 'numeric');
SELECT is(
  synapse_permanence_learn(0.00001), 
  0.0, 
  'synapse_permanence_learn() unlearns down to min 0.0'
);
SELECT cmp_ok(
  synapse_permanence_learn(0.11), 
  '<', 
  0.11, 
  'synapse_permanence_learn() unlearns down below threshold'
);
SELECT cmp_ok(
  synapse_permanence_learn(0.88), 
  '>', 
  0.88, 
  'synapse_permanence_learn() learns up above threshold'
);
SELECT is(
  synapse_permanence_learn(0.99999), 
  1.0, 
  'synapse_permanence_learn() learns up to max 1.0'
);

-- test synapse_potential()
SELECT has_function('synapse_potential', ARRAY['numeric']);
SELECT function_lang_is('synapse_potential', 'plpgsql');
SELECT function_returns('synapse_potential', 'boolean');
SELECT is(synapse_potential(0.0), false, 'synapse_potential() works min');
SELECT is(
  synapse_potential(config('SynapseIncrement')::NUMERIC), 
  true,
  'synapse_potential() true over min'
);
SELECT is(synapse_potential(1.00), true, 'synapse_potential() works max');

-- test synapse_connection_collapse()
SELECT has_function('synapse_connection_collapse', ARRAY['numeric']);
SELECT function_lang_is('synapse_connection_collapse', 'plpgsql');
SELECT function_returns('synapse_connection_collapse', 'synapse_connection');
SELECT is(
  synapse_connection_collapse(0.00), 
  'unconnected', 
  'synapse_connection_collapse() works zero'
);
SELECT is(
  synapse_connection_collapse(config('SynapseMinimum')::NUMERIC), 
  'unconnected', 
  'synapse_connection_collapse() works min'
);
SELECT is(
  synapse_connection_collapse(
    config('SynapseMinimum')::NUMERIC + 
    config('SynapseIncrement')::NUMERIC
  ), 
  'potential',
  'synapse_connection_collapse() works above min'
);
SELECT is(
  synapse_connection_collapse(config('SynapseThreshold')::NUMERIC), 
  'potential',
  'synapse_connection_collapse() works on threshold'
);
SELECT is(
  synapse_connection_collapse(
    config('SynapseThreshold')::NUMERIC + 
    config('SynapseIncrement')::NUMERIC
  ), 
  'connected',
  'synapse_connection_collapse() works beyond threshold'
);
SELECT is(
  synapse_connection_collapse(1.00), 
  'connected', 
  'synapse_connection_collapse() works max'
);

-- test synapse_connection_update()
SELECT has_function('synapse_connection_update');
SELECT function_lang_is('synapse_connection_update', 'plpgsql');
SELECT function_returns('synapse_connection_update', 'trigger');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

