/**
 * Link Neuron to Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM link_distal_neuron_synapse; $$,
  ROW((
    config('neuron_count')::INT *
    config('dendrite_count')::INT *
    config('synapse_count')::INT
  )::BIGINT),
  'Link_Neuron_Synapse has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

