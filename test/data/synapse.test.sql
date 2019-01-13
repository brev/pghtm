/**
 * Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


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

SELECT row_eq(
  $$ 
    SELECT (COUNT(id) > 0)
    FROM synapse 
    WHERE permanence < (
      config('SynapseThreshold')::NUMERIC - config('SynapseDecrement')::NUMERIC
    )
    OR permanence > (
      config('SynapseThreshold')::NUMERIC + config('SynapseIncrement')::NUMERIC
    )
  $$,
  ROW(FALSE),
  'Synapse permanences are initialized in small range around threshold'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3,4]);
SELECT row_eq(
  $$ 
    SELECT (COUNT(id) > 0)
    FROM synapse 
    WHERE permanence < (
      config('SynapseThreshold')::NUMERIC - config('SynapseDecrement')::NUMERIC
    )
    OR permanence > (
      config('SynapseThreshold')::NUMERIC + config('SynapseIncrement')::NUMERIC
    )
  $$,
  ROW(TRUE),
  'Synapse permanences grow away from threshold range from learning'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

