/**
 * HTM Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(48);  -- Test count


-- test config()
SELECT has_function('config', ARRAY['character varying']);
SELECT function_lang_is('config', 'plpgsql');
SELECT function_returns('config', 'character varying');
SELECT volatility_is('config', 'immutable');
SELECT is(config('UnitTestData'), 777::varchar, 'config() works directly');
SELECT is(
  config('NeuronCount')::INT, 
  config('ColumnCount')::INT * config('RowCount')::INT,
  'config() rows * columns = neurons'
);
SELECT throws_ok(
  'SELECT config(''loremipsum'')', 
  'No value for key loremipsum', 
  'Errors on bad key'
);

-- test count_unloop()
SELECT has_function('count_unloop', ARRAY['integer', 'integer', 'integer']);
SELECT function_lang_is('count_unloop', 'plpgsql');
SELECT function_returns('count_unloop', 'integer');
SELECT is(count_unloop(1, 1, 3), 1, 'count_unloop() works 1');
SELECT is(count_unloop(1, 2, 3), 2, 'count_unloop() works 2');
SELECT is(count_unloop(1, 3, 3), 3, 'count_unloop() works 3');
SELECT is(count_unloop(2, 1, 3), 4, 'count_unloop() works 4');
SELECT is(count_unloop(2, 2, 3), 5, 'count_unloop() works 5');
SELECT is(count_unloop(2, 3, 3), 6, 'count_unloop() works 6');

-- test duty_cycle_period()
SELECT has_function('duty_cycle_period');
SELECT function_lang_is('duty_cycle_period', 'plpgsql');
SELECT function_returns('duty_cycle_period', 'integer');
SELECT sp_set('compute_iteration', 10::VARCHAR);
SELECT is(
  duty_cycle_period(),
  10, 
  'duty_cycle_period() works cool'
);
SELECT sp_set('compute_iteration', 2000::VARCHAR);
SELECT is(
  duty_cycle_period(),
  1000, 
  'duty_cycle_period() works warm'
);

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

-- test wrap_array_index()
SELECT has_function('wrap_array_index', ARRAY['integer', 'integer']);
SELECT function_lang_is('wrap_array_index', 'plpgsql');
SELECT function_returns('wrap_array_index', 'integer');
SELECT is(wrap_array_index(-2, 5), 3, 'wrap_array_index() works under 2');
SELECT is(wrap_array_index(-1, 5), 4, 'wrap_array_index() works under 1');
SELECT is(wrap_array_index(0, 5), 0, 'wrap_array_index() works min');
SELECT is(wrap_array_index(4, 5), 4, 'wrap_array_index() works max');
SELECT is(wrap_array_index(5, 5), 0, 'wrap_array_index() works over 1');
SELECT is(wrap_array_index(6, 5), 1, 'wrap_array_index() works over 2');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

