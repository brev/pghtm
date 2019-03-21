/**
 * Cell Function Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(13);  -- Test count


-- test cell_active_update()
SELECT has_function('cell_active_update');
SELECT function_lang_is('cell_active_update', 'plpgsql');
SELECT function_returns('cell_active_update', 'trigger');

-- test cell_active_last_update()
SELECT has_function('cell_active_last_update');
SELECT function_lang_is('cell_active_last_update', 'plpgsql');
SELECT function_returns('cell_active_last_update', 'trigger');

-- test cell_anchor_synapse_segment_grow_update()
SELECT has_function('cell_anchor_synapse_segment_grow_update');
SELECT function_lang_is('cell_anchor_synapse_segment_grow_update', 'plpgsql');
SELECT function_returns('cell_anchor_synapse_segment_grow_update', 'trigger');

-- test cell_is_predict()
SELECT has_function('cell_is_predict', ARRAY['integer']);
SELECT function_lang_is('cell_is_predict', 'plpgsql');
SELECT volatility_is('cell_is_predict', 'stable');
SELECT function_returns('cell_is_predict', 'boolean');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

