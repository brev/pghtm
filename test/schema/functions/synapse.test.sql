/**
 * Synapse Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(33);  -- Test count


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

-- test synapse_state_collapse()
SELECT has_function('synapse_state_collapse', ARRAY['numeric']);
SELECT function_lang_is('synapse_state_collapse', 'plpgsql');
SELECT function_returns('synapse_state_collapse', 'synapse_state');
SELECT is(
  synapse_state_collapse(0.00), 
  'disconnected', 
  'synapse_state_collapse() works zero'
);
SELECT is(
  synapse_state_collapse(config('SynapseMinimum')::NUMERIC), 
  'disconnected', 
  'synapse_state_collapse() works min'
);
SELECT is(
  synapse_state_collapse(
    config('SynapseMinimum')::NUMERIC + 
    config('SynapseIncrement')::NUMERIC
  ), 
  'potential',
  'synapse_state_collapse() works above min'
);
SELECT is(
  synapse_state_collapse(config('SynapseThreshold')::NUMERIC), 
  'potential',
  'synapse_state_collapse() works on threshold'
);
SELECT is(
  synapse_state_collapse(
    config('SynapseThreshold')::NUMERIC + 
    config('SynapseIncrement')::NUMERIC
  ), 
  'connected',
  'synapse_state_collapse() works beyond threshold'
);
SELECT is(
  synapse_state_collapse(1.00), 
  'connected', 
  'synapse_state_collapse() works max'
);

-- test synapse_update_field_state()
SELECT has_function('synapse_update_field_state');
SELECT function_lang_is('synapse_update_field_state', 'plpgsql');
SELECT function_returns('synapse_update_field_state', 'trigger');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

