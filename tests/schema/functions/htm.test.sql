/**
 * HTM Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(32);  -- Test count


SELECT has_function('config_int', ARRAY['character varying']);
SELECT function_lang_is('config_int', 'plpgsql');
SELECT function_returns('config_int', 'integer');
SELECT is(config_int('UnitTestDummyData'), 777, 'config_int() works directly');
SELECT is(
  config_int('DataSimpleCountNeuron'), 
  config_int('DataSimpleCountColumn') * config_int('DataSimpleCountRow'),
  'config_int() rows * columns = neurons'
);

SELECT has_function('config_numeric', ARRAY['character varying']);
SELECT function_lang_is('config_numeric', 'plpgsql');
SELECT function_returns('config_numeric', 'numeric');
SELECT is(config_numeric('UnitTestDummyData'), 6.66, 'config_numeric() works');

SELECT has_function('count_unloop', ARRAY['integer', 'integer', 'integer']);
SELECT function_lang_is('count_unloop', 'plpgsql');
SELECT function_returns('count_unloop', 'integer');
SELECT is(count_unloop(1, 1, 3), 1, 'count_unloop() works 1');
SELECT is(count_unloop(1, 2, 3), 2, 'count_unloop() works 2');
SELECT is(count_unloop(1, 3, 3), 3, 'count_unloop() works 3');
SELECT is(count_unloop(2, 1, 3), 4, 'count_unloop() works 4');
SELECT is(count_unloop(2, 2, 3), 5, 'count_unloop() works 5');
SELECT is(count_unloop(2, 3, 3), 6, 'count_unloop() works 6');

SELECT has_function('random_range', ARRAY['integer', 'integer']);
SELECT function_lang_is('random_range', 'plpgsql');
SELECT function_returns('random_range', 'integer');
SELECT cmp_ok(random_range(5,7), '>=', 5, 'random_range() works lo');
SELECT cmp_ok(random_range(5,7), '<=', 7, 'random_range() works hi');

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

