/**
 * Dendrite Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM dendrite; $$, 
  ROW((
    (
      const('neuron_count')::INT *
      const('dendrite_count')::INT
    ) + 
    const('column_count')::INT
  )::BIGINT), 
  'Dendrite has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

