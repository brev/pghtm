/**
 * Input Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(8);  -- Test count


-- test input_columns_active_update()
SELECT has_function('input_columns_active_update');
SELECT function_lang_is('input_columns_active_update', 'plpgsql');
SELECT function_returns('input_columns_active_update', 'trigger');

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

