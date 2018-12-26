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
  synapse_weight(config('ThresholdSynapse')::NUMERIC - 0.01), 
  false,
  'synapse_weight() false under threshold'
);
SELECT is(
  synapse_weight(config('ThresholdSynapse')::NUMERIC), 
  false,
  'synapse_weight() false on threshold'
);
SELECT is(
  synapse_weight(
    config('ThresholdSynapse')::NUMERIC + 
    config('synPermActiveInc')::NUMERIC
  ), 
  true,
  'synapse_weight() true beyond threshold'
);
SELECT is(synapse_weight(1.00), true, 'synapse_weight() works max');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

