/**
 * Input Function Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(14);  -- Test count


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
  'boolean',
  'integer',
  'integer',
  'integer'
]);
SELECT function_lang_is('input_encode_integer', 'plpgsql');
SELECT volatility_is('input_encode_integer', 'immutable');
SELECT function_returns('input_encode_integer', 'integer[]');

-- test input_rows_count()
SELECT has_function('input_rows_count');
SELECT function_lang_is('input_rows_count', 'plpgsql');
SELECT volatility_is('input_rows_count', 'stable');
SELECT function_returns('input_rows_count', 'bigint');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

