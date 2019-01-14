/**
 * Link Dendrite to Neuron Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM link_dendrite_neuron; $$, 
  ROW((
    const('NeuronCount')::INT *
    const('DendriteCount')::INT
  )::BIGINT), 
  'Link_Dendrite_Neuron has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

