/**
 * Dendrite Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(7);  -- Test count


-- test dendrite_active()
SELECT has_function('dendrite_active', ARRAY['integer']);
SELECT function_lang_is('dendrite_active', 'plpgsql');
SELECT function_returns('dendrite_active', 'boolean');
SELECT is(dendrite_active(0), FALSE, 'dendrite_active() works min');
SELECT is(
  dendrite_active(config('DendriteThreshold')::INTEGER), 
  FALSE,
  'dendrite_active() false on threshold'
);
SELECT is(
  dendrite_active(config('DendriteThreshold')::INTEGER + 1), 
  TRUE,
  'dendrite_active() true beyond threshold'
);
SELECT is(
  dendrite_active(config('SynapseCount')::INTEGER), 
  TRUE,
  'dendrite_active() true at max'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

