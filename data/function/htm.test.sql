/**
 * HTM Function Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(13);  -- Test count


-- test random_range_int()
SELECT cmp_ok(
  random_range_int(5, 7),
  '>=',
  5,
  'random_range_int() works lo'
);
SELECT cmp_ok(
  random_range_int(5, 7),
  '<=',
  7,
  'random_range_int() works hi'
);

-- test random_range_numeric()
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

-- test sort_array()
SELECT is(sort_array(ARRAY[3,1,2]), ARRAY[1,2,3], 'sort_array() works');

-- test wrap_array_index()
SELECT is(wrap_array_index(-2, 5), 3, 'wrap_array_index() works under 2');
SELECT is(wrap_array_index(-1, 5), 4, 'wrap_array_index() works under 1');
SELECT is(wrap_array_index(0, 5), 0, 'wrap_array_index() works min');
SELECT is(wrap_array_index(4, 5), 4, 'wrap_array_index() works max');
SELECT is(wrap_array_index(5, 5), 0, 'wrap_array_index() works over 1');
SELECT is(wrap_array_index(6, 5), 1, 'wrap_array_index() works over 2');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

