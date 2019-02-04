/**
 * Segment Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(7);  -- Test count


-- test segment_is_active()
SELECT has_function('segment_is_active', ARRAY['integer']);
SELECT function_lang_is('segment_is_active', 'plpgsql');
SELECT volatility_is('segment_is_active', 'stable');
SELECT function_returns('segment_is_active', 'boolean');
SELECT is(segment_is_active(0), FALSE, 'segment_is_active() works min');
SELECT is(
  segment_is_active(config('segment_synapse_threshold')::INT),
  FALSE,
  'segment_is_active() false on threshold'
);
SELECT is(
  segment_is_active(config('segment_synapse_threshold')::INT + 1),
  TRUE,
  'segment_is_active() true beyond threshold'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

