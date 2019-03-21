/**
 * HTM Function Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(26);  -- Test count


-- test debug()
SELECT has_function('debug', ARRAY['text']);
SELECT function_lang_is('debug', 'plpgsql');
SELECT volatility_is('debug', 'stable');

-- test random_range_int()
SELECT has_function('random_range_int', ARRAY['integer', 'integer']);
SELECT function_lang_is('random_range_int', 'plpgsql');
SELECT function_returns('random_range_int', 'integer');
SELECT cmp_ok(random_range_int(5, 7), '>=', 5, 'random_range_int() works lo');
SELECT cmp_ok(random_range_int(5, 7), '<=', 7, 'random_range_int() works hi');

-- test random_range_numeric()
SELECT has_function('random_range_numeric', ARRAY['numeric', 'numeric']);
SELECT function_lang_is('random_range_numeric', 'plpgsql');
SELECT function_returns('random_range_numeric', 'numeric');

-- test running_moving_average()
SELECT has_function(
  'running_moving_average',
  ARRAY['numeric', 'numeric', 'integer']
);
SELECT function_lang_is('running_moving_average', 'plpgsql');
SELECT volatility_is('running_moving_average', 'immutable');
SELECT function_returns('running_moving_average', 'numeric');

-- test schema_modified_update()
SELECT has_function('schema_modified_update');
SELECT function_lang_is('schema_modified_update', 'plpgsql');
SELECT function_returns('schema_modified_update', 'trigger');

-- test sort_array()
SELECT has_function('sort_array', ARRAY['integer[]']);
SELECT function_lang_is('sort_array', 'plpgsql');
SELECT volatility_is('sort_array', 'immutable');
SELECT function_returns('sort_array', 'integer[]');

-- test wrap_array_index()
SELECT has_function('wrap_array_index', ARRAY['integer', 'integer']);
SELECT function_lang_is('wrap_array_index', 'plpgsql');
SELECT volatility_is('wrap_array_index', 'immutable');
SELECT function_returns('wrap_array_index', 'integer');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

