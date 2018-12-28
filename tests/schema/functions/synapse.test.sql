/**
 * Synapse Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(8);  -- Test count


SELECT has_function('synapse_connection', ARRAY['numeric']);
SELECT function_lang_is('synapse_connection', 'plpgsql');
SELECT function_returns('synapse_connection', 'boolean');
SELECT is(synapse_connection(0.00), false, 'synapse_connection() works min');
SELECT is(
  synapse_connection(
    config('ThresholdSynapse')::NUMERIC - 
    config('SynapseDecrement')::NUMERIC
  ), 
  false,
  'synapse_connection() false under threshold'
);
SELECT is(
  synapse_connection(config('ThresholdSynapse')::NUMERIC), 
  false,
  'synapse_connection() false on threshold'
);
SELECT is(
  synapse_connection(
    config('ThresholdSynapse')::NUMERIC + 
    config('SynapseIncrement')::NUMERIC
  ), 
  true,
  'synapse_connection() true beyond threshold'
);
SELECT is(synapse_connection(1.00), true, 'synapse_connection() works max');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

