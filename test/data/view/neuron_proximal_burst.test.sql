/**
 * Neuron (Proximal: Burst) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test neuron_proximal_burst
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM neuron_proximal_burst $$,
  ROW(FALSE),
  'Neuron Proximal Burst view has valid init count'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM neuron_proximal_burst $$,
  ROW(TRUE),
  'Neuron Proximal Burst view has valid count after data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data
