/**
 * Synapse Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(8);  -- Test count


SELECT has_function('synapse_weight', ARRAY['numeric']);
SELECT function_lang_is('synapse_weight', 'plpgsql');
SELECT function_returns('synapse_weight', 'boolean');
SELECT is(synapse_weight(0.00), false, 'synapse_weight() works min');
SELECT is(
  synapse_weight(config_numeric('ThresholdSynapsePermanence') - 0.01), 
  false,
  'synapse_weight() works under'
);
SELECT is(
  synapse_weight(config_numeric('ThresholdSynapsePermanence')), 
  true,
  'synapse_weight() works on'
);
SELECT is(
  synapse_weight(config_numeric('ThresholdSynapsePermanence') + 0.01), 
  true,
  'synapse_weight() works over'
);
SELECT is(synapse_weight(1.00), true, 'synapse_weight() works max');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

