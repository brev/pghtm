/**
 * HTM Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(37);  -- Test count


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
SELECT cmp_ok(
  random_range_numeric(7.0, 9.0),
  '>=',
  7.0,
  'random_range_numeric() works lo'
);
SELECT cmp_ok(
  random_range_numeric(7.0, 9.0),
  '<=',
  9.0,
  'random_range_numeric() works hi'
);

-- test running_moving_average()
SELECT has_function(
  'running_moving_average',
  ARRAY['numeric', 'numeric', 'integer']
);
SELECT function_lang_is('running_moving_average', 'plpgsql');
SELECT volatility_is('running_moving_average', 'immutable');
SELECT function_returns('running_moving_average', 'numeric');
SELECT is(
  running_moving_average(0.5, 0, 1000),
  0.4995,
  'running_moving_average() works lo'
);
SELECT is(
  running_moving_average(0.5, 1, 1000),
  0.5005,
  'running_moving_average() works hi'
);

-- test schema_modified_update()
SELECT has_function('schema_modified_update');
SELECT function_lang_is('schema_modified_update', 'plpgsql');
SELECT function_returns('schema_modified_update', 'trigger');

-- test sort_array()
SELECT has_function('sort_array', ARRAY['integer[]']);
SELECT function_lang_is('sort_array', 'plpgsql');
SELECT volatility_is('sort_array', 'immutable');
SELECT function_returns('sort_array', 'integer[]');
SELECT is(sort_array(ARRAY[3,1,2]), ARRAY[1,2,3], 'sort_array() works');

-- test wrap_array_index()
SELECT has_function('wrap_array_index', ARRAY['integer', 'integer']);
SELECT function_lang_is('wrap_array_index', 'plpgsql');
SELECT volatility_is('wrap_array_index', 'immutable');
SELECT function_returns('wrap_array_index', 'integer');
SELECT is(wrap_array_index(-2, 5), 3, 'wrap_array_index() works under 2');
SELECT is(wrap_array_index(-1, 5), 4, 'wrap_array_index() works under 1');
SELECT is(wrap_array_index(0, 5), 0, 'wrap_array_index() works min');
SELECT is(wrap_array_index(4, 5), 4, 'wrap_array_index() works max');
SELECT is(wrap_array_index(5, 5), 0, 'wrap_array_index() works over 1');
SELECT is(wrap_array_index(6, 5), 1, 'wrap_array_index() works over 2');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

