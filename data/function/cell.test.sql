/**
 * Cell Function Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(4);  -- Test count


-- test cell_is_predict()
SELECT is(
  cell_is_predict(0),
  FALSE,
  'cell_is_predict() works min'
);
SELECT is(
  cell_is_predict(config('cell_segment_threshold')::INT),
  FALSE,
  'cell_is_predict() false on threshold'
);
SELECT is(
  cell_is_predict(config('cell_segment_threshold')::INT + 1),
  TRUE,
  'cell_is_predict() true beyond threshold'
);
SELECT is(
  cell_is_predict(config('segment_count')::INT),
  TRUE,
  'cell_is_predict() true at max'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

