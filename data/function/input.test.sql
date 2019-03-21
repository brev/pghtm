/**
 * Input Function Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(10);  -- Test count


-- test input_encode_integer()
SELECT is(
  input_encode_integer(10, 0.3, False, 1, 10, 1),
  ARRAY[0, 1, 2],
  'input_encode_integer() works low, not wrapped'
);
SELECT is(
  input_encode_integer(10, 0.3, False, 1, 10, 10),
  ARRAY[7, 8, 9],
  'input_encode_integer() works high, not wrapped'
);
SELECT is(
  input_encode_integer(10, 0.3, True, 1, 10, 1),
  ARRAY[0, 1, 9],
  'input_encode_integer() works low, wrapped'
);
SELECT is(
  input_encode_integer(10, 0.3, True, 1, 10, 10),
  ARRAY[0, 8, 9],
  'input_encode_integer() works high, wrapped'
);
SELECT is(
  input_encode_integer(10, 0.3, False, 11, 20, 11),
  ARRAY[0, 1, 2],
  'input_encode_integer() works low, not wrapped, with min/max'
);
SELECT is(
  input_encode_integer(10, 0.3, False, 11, 20, 20),
  ARRAY[7, 8, 9],
  'input_encode_integer() works high, not wrapped, with min/max'
);
SELECT is(
  input_encode_integer(10, 0.3, True, 11, 20, 11),
  ARRAY[0, 1, 9],
  'input_encode_integer() works low, wrapped, with min/max'
);
SELECT is(
  input_encode_integer(10, 0.3, True, 11, 20, 20),
  ARRAY[0, 8, 9],
  'input_encode_integer() works high, wrapped, with min/max'
);

-- test input_rows_count()
SELECT row_eq(
  $$ SELECT COUNT(id) FROM input; $$,
  ROW(input_rows_count()),
  'input_rows_count() works'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
SELECT row_eq(
  $$ SELECT COUNT(id) FROM input; $$,
  ROW(input_rows_count()),
  'input_rows_count() works'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

