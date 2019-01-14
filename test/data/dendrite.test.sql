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
      const('NeuronCount')::INT *
      const('DendriteCount')::INT
    ) + 
    const('ColumnCount')::INT
  )::BIGINT), 
  'Dendrite has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

