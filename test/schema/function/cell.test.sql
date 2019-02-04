/**
 * Cell Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(17);  -- Test count


-- test cell_active_update()
SELECT has_function('cell_active_update');
SELECT function_lang_is('cell_active_update', 'plpgsql');
SELECT function_returns('cell_active_update', 'trigger');

-- test cell_active_last_update()
SELECT has_function('cell_active_last_update');
SELECT function_lang_is('cell_active_last_update', 'plpgsql');
SELECT function_returns('cell_active_last_update', 'trigger');

-- test cell_anchor_segment_synapse_grow_update()
SELECT has_function('cell_anchor_segment_synapse_grow_update');
SELECT function_lang_is('cell_anchor_segment_synapse_grow_update', 'plpgsql');
SELECT function_returns('cell_anchor_segment_synapse_grow_update', 'trigger');

-- test cell_is_predict()
SELECT has_function('cell_is_predict', ARRAY['integer']);
SELECT function_lang_is('cell_is_predict', 'plpgsql');
SELECT volatility_is('cell_is_predict', 'stable');
SELECT function_returns('cell_is_predict', 'boolean');
SELECT is(
  cell_is_predict(0),
  FALSE,
  'cell_is_predict() works min'
);
SELECT is(
  cell_is_predict(config('cell_segment_threshold')::INT),
  FALSE,
  'cell_is_predict() false on threshold'
);
SELECT is(
  cell_is_predict(config('cell_segment_threshold')::INT + 1),
  TRUE,
  'cell_is_predict() true beyond threshold'
);
SELECT is(
  cell_is_predict(config('segment_count')::INT),
  TRUE,
  'cell_is_predict() true at max'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

