/**
 * Dendrite Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(8);  -- Test count


SELECT has_function('dendrite_activation', ARRAY['int8']);
SELECT function_lang_is('dendrite_activation', 'plpgsql');
SELECT function_returns('dendrite_activation', 'boolean');
SELECT is(dendrite_activation(0), false, 'dendrite_activation() works min');
SELECT is(
  dendrite_activation(config('ThresholdDendriteSynapse')::INT - 1), 
  false,
  'dendrite_activation() false under threshold'
);
SELECT is(
  dendrite_activation(config('ThresholdDendriteSynapse')::INT), 
  false,
  'dendrite_activation() false on threshold'
);
SELECT is(
  dendrite_activation(config('ThresholdDendriteSynapse')::INT + 1), 
  true,
  'dendrite_activation() true beyond threshold'
);
SELECT is(
  dendrite_activation(config('CountSynapse')::INT), 
  true,
  'dendrite_activation() works max'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

