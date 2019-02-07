/**
 * Schema-wide Sequences Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT sequences_are(ARRAY[
  'cell_id_seq',
  'column_id_seq',
  'input_id_seq',
  'link_distal_cell_synapse_id_seq',
  'link_distal_segment_cell_id_seq',
  'link_proximal_input_synapse_id_seq',
  'link_proximal_segment_column_id_seq',
  'region_id_seq',
  'segment_id_seq',
  'synapse_id_seq'
]);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

