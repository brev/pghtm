/**
 * Link Neuron to Synapse Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(13);  -- Test count


SELECT has_table('link_distal_neuron_synapse');
SELECT columns_are(
  'link_distal_neuron_synapse',
  ARRAY['id', 'neuron_id', 'synapse_id']
);
SELECT has_pk('link_distal_neuron_synapse');
SELECT has_fk('link_distal_neuron_synapse');

SELECT col_type_is('link_distal_neuron_synapse', 'id', 'integer');
SELECT col_not_null('link_distal_neuron_synapse', 'id');
SELECT col_is_pk('link_distal_neuron_synapse', 'id');

SELECT col_type_is('link_distal_neuron_synapse', 'neuron_id', 'integer');
SELECT col_not_null('link_distal_neuron_synapse', 'neuron_id');
SELECT col_is_fk('link_distal_neuron_synapse', 'neuron_id');

SELECT col_type_is('link_distal_neuron_synapse', 'synapse_id', 'integer');
SELECT col_not_null('link_distal_neuron_synapse', 'synapse_id');
SELECT col_is_fk('link_distal_neuron_synapse', 'synapse_id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

