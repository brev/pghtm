/**
 * Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM synapse; $$, 
  ROW((
    (
      config('NeuronCount')::INT * 
      config('DendriteCount')::INT *
      config('SynapseCount')::INT
    ) + (
      config('ColumnCount')::INT *
      config('SynapseCount')::INT
    )
  )::BIGINT), 
  'Synapse has valid count total'
);

SELECT row_eq($$ 
  SELECT COUNT(id) 
    FROM synapse 
    WHERE permanence < (
      config('SynapseThreshold')::NUMERIC - config('SynapseDecrement')::NUMERIC
    )
    OR permanence > (
      config('SynapseThreshold')::NUMERIC + config('SynapseIncrement')::NUMERIC
    ); 
  $$,
  ROW(0::BIGINT),
  'Synapse permanences are initialized in small range around threshold'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

