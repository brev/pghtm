/**
 * Synapse Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(15);  -- Test count


SELECT has_function('synapse_connected', ARRAY['numeric']);
SELECT function_lang_is('synapse_connected', 'plpgsql');
SELECT function_returns('synapse_connected', 'boolean');
SELECT is(synapse_connected(0.00), false, 'synapse_connected() works min');
SELECT is(
  synapse_connected(
    config('ThresholdSynapse')::NUMERIC - 
    config('SynapseDecrement')::NUMERIC
  ), 
  false,
  'synapse_connected() false under threshold'
);
SELECT is(
  synapse_connected(config('ThresholdSynapse')::NUMERIC), 
  false,
  'synapse_connected() false on threshold'
);
SELECT is(
  synapse_connected(
    config('ThresholdSynapse')::NUMERIC + 
    config('SynapseIncrement')::NUMERIC
  ), 
  true,
  'synapse_connected() true beyond threshold'
);
SELECT is(synapse_connected(1.00), true, 'synapse_connected() works max');

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

SELECT has_function('synapse_update_field_state');
SELECT function_lang_is('synapse_update_field_state', 'plpgsql');
SELECT function_returns('synapse_update_field_state', 'trigger');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

