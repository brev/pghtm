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
  dendrite_activation(config_int('ThresholdDendriteSynapse') - 1), 
  false,
  'dendrite_activation() works under'
);
SELECT is(
  dendrite_activation(config_int('ThresholdDendriteSynapse')), 
  true,
  'dendrite_activation() works on'
);
SELECT is(
  dendrite_activation(config_int('ThresholdDendriteSynapse') + 1), 
  true,
  'dendrite_activation() works over'
);
SELECT is(
  dendrite_activation(config_int('DataSimpleCountSynapse')), 
  true,
  'dendrite_activation() works max'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

