/**
 * Dendrite Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(8);  -- Test count


SELECT has_function('dendrite_activated', ARRAY['int8']);
SELECT function_lang_is('dendrite_activated', 'plpgsql');
SELECT function_returns('dendrite_activated', 'boolean');
SELECT is(dendrite_activated(0), false, 'dendrite_activated() works min');
SELECT is(
  dendrite_activated(config('DendriteThreshold')::INT - 1), 
  false,
  'dendrite_activated() false under threshold'
);
SELECT is(
  dendrite_activated(config('DendriteThreshold')::INT), 
  false,
  'dendrite_activated() false on threshold'
);
SELECT is(
  dendrite_activated(config('DendriteThreshold')::INT + 1), 
  true,
  'dendrite_activated() true beyond threshold'
);
SELECT is(
  dendrite_activated(config('SynapseCount')::INT), 
  true,
  'dendrite_activated() works max'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

