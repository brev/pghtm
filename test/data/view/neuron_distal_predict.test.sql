/**
 * Neuron (Distal: Predict) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test neuron_distal_predict
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM neuron_distal_predict $$,
  ROW(FALSE),
  'Neuron Distal Predict view has valid init count'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM neuron_distal_predict $$,
  ROW(TRUE),
  'Neuron Distal Predict view has valid count after data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

