/**
 * Link Neuron to Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM link_neuron_synapse; $$, 
  ROW((
    config('CountNeuron')::INT *
    config('CountDendrite')::INT *
    config('CountSynapse')::INT
  )::BIGINT), 
  'Link_Neuron_Synapse has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

