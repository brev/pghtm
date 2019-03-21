/**
 * Segment Function Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(7);  -- Test count


-- test segment_anchor_grow_updates()
SELECT has_function('segment_anchor_grow_updates', ARRAY['integer[]']);
SELECT function_lang_is('segment_anchor_grow_updates', 'plpgsql');
SELECT function_returns('segment_anchor_grow_updates', 'integer[]');

-- test segment_is_active()
SELECT has_function('segment_is_active', ARRAY['integer']);
SELECT function_lang_is('segment_is_active', 'plpgsql');
SELECT volatility_is('segment_is_active', 'stable');
SELECT function_returns('segment_is_active', 'boolean');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

