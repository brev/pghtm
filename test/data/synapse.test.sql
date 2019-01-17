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
      config('neuron_count')::INT *
      config('dendrite_count')::INT *
      config('synapse_count')::INT
    ) + (
      config('column_count')::INT *
      config('synapse_count')::INT
    )
  )::BIGINT),
  'Synapse has valid count total'
);

SELECT row_eq(
  $$
    SELECT (COUNT(id) > 0)
    FROM synapse
    WHERE permanence < (
      config('synapse_threshold')::NUMERIC - config('synapse_decrement')::NUMERIC
    )
    OR permanence > (
      config('synapse_threshold')::NUMERIC + config('synapse_increment')::NUMERIC
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
      config('synapse_threshold')::NUMERIC - config('synapse_decrement')::NUMERIC
    )
    OR permanence > (
      config('synapse_threshold')::NUMERIC + config('synapse_increment')::NUMERIC
    )
  $$,
  ROW(TRUE),
  'Synapse permanences grow away from threshold range from learning'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

