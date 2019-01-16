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
      const('neuron_count')::INT * 
      const('dendrite_count')::INT *
      const('synapse_count')::INT
    ) + (
      const('column_count')::INT *
      const('synapse_count')::INT
    )
  )::BIGINT), 
  'Synapse has valid count total'
);

SELECT row_eq(
  $$ 
    SELECT (COUNT(id) > 0)
    FROM synapse 
    WHERE permanence < (
      var('synapse_threshold')::NUMERIC - var('synapse_decrement')::NUMERIC
    )
    OR permanence > (
      var('synapse_threshold')::NUMERIC + var('synapse_increment')::NUMERIC
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
      var('synapse_threshold')::NUMERIC - var('synapse_decrement')::NUMERIC
    )
    OR permanence > (
      var('synapse_threshold')::NUMERIC + var('synapse_increment')::NUMERIC
    )
  $$,
  ROW(TRUE),
  'Synapse permanences grow away from threshold range from learning'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

