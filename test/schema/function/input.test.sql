/**
 * Input Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(17);  -- Test count


-- test input_columns_active_update()
SELECT has_function('input_columns_active_update');
SELECT function_lang_is('input_columns_active_update', 'plpgsql');
SELECT function_returns('input_columns_active_update', 'trigger');

-- test input_columns_predict_update()
SELECT has_function('input_columns_predict_update');
SELECT function_lang_is('input_columns_predict_update', 'plpgsql');
SELECT function_returns('input_columns_predict_update', 'trigger');

-- test input_encode_integer()
SELECT has_function('input_encode_integer', ARRAY[
  'integer',
  'numeric',
  'integer',
  'integer',
  'boolean',
  'integer'
]);
SELECT function_lang_is('input_encode_integer', 'plpgsql');
SELECT volatility_is('input_encode_integer', 'immutable');
SELECT function_returns('input_encode_integer', 'integer[]');
SELECT is(
  input_encode_integer(10, 0.3, 1, 10, False, 1),
  ARRAY[0, 1, 2],
  'input_encode_integer() works min nowrap'
);
SELECT is(
  input_encode_integer(10, 0.3, 1, 10, True, 1),
  ARRAY[0, 1, 2],
  'input_encode_integer() works min wrapped'
);

-- test input_rows_count()
SELECT has_function('input_rows_count');
SELECT function_lang_is('input_rows_count', 'plpgsql');
SELECT volatility_is('input_rows_count', 'stable');
SELECT function_returns('input_rows_count', 'bigint');
SELECT row_eq(
  $$ SELECT COUNT(id) FROM input; $$,
  ROW(input_rows_count()),
  'input_rows_count() works'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

