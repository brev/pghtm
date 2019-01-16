/**
 * Link Neuron to Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM link_neuron_synapse; $$, 
  ROW((
    const('neuron_count')::INT *
    const('dendrite_count')::INT *
    const('synapse_count')::INT
  )::BIGINT), 
  'Link_Neuron_Synapse has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

