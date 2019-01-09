/**
 * Link Dendrite to Neuron Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(13);  -- Test count


SELECT has_table('link_dendrite_neuron');
SELECT columns_are(
  'link_dendrite_neuron', 
  ARRAY['id', 'dendrite_id', 'neuron_id']
);
SELECT has_pk('link_dendrite_neuron');
SELECT has_fk('link_dendrite_neuron');

SELECT col_type_is('link_dendrite_neuron', 'id', 'integer');
SELECT col_not_null('link_dendrite_neuron', 'id');
SELECT col_is_pk('link_dendrite_neuron', 'id');

SELECT col_type_is('link_dendrite_neuron', 'dendrite_id', 'integer');
SELECT col_not_null('link_dendrite_neuron', 'dendrite_id');
SELECT col_is_fk('link_dendrite_neuron', 'dendrite_id');

SELECT col_type_is('link_dendrite_neuron', 'neuron_id', 'integer');
SELECT col_not_null('link_dendrite_neuron', 'neuron_id');
SELECT col_is_fk('link_dendrite_neuron', 'neuron_id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

