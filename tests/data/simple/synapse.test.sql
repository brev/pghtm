/**
 * Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM synapse; $$, 
  ROW((
    (
      config('CountNeuron')::INT * 
      config('CountDendrite')::INT *
      config('CountSynapse')::INT
    ) + (
      config('CountColumn')::INT *
      config('CountSynapse')::INT
    )
  )::BIGINT), 
  'Synapse has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

