/**
 * Dendrite Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(7);  -- Test count


-- test dendrite_is_active()
SELECT has_function('dendrite_is_active', ARRAY['integer']);
SELECT function_lang_is('dendrite_is_active', 'plpgsql');
SELECT function_returns('dendrite_is_active', 'boolean');
SELECT is(dendrite_is_active(0), FALSE, 'dendrite_is_active() works min');
SELECT is(
  dendrite_is_active(config('dendrite_threshold')::INTEGER),
  FALSE,
  'dendrite_is_active() false on threshold'
);
SELECT is(
  dendrite_is_active(config('dendrite_threshold')::INTEGER + 1),
  TRUE,
  'dendrite_is_active() true beyond threshold'
);
SELECT is(
  dendrite_is_active(config('synapse_count')::INTEGER),
  TRUE,
  'dendrite_is_active() true at max'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

