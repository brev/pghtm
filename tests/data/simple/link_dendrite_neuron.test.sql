/**
 * Link Dendrite to Neuron Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM link_dendrite_neuron; $$, 
  ROW((
    config_int('DataSimpleCountNeuron') *
    config_int('DataSimpleCountDendrite')
  )::bigint), 
  'Link_Dendrite_Neuron has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

