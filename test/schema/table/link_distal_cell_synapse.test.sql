/**
 * Link Cell to Synapse Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(15);  -- Test count


SELECT has_table('link_distal_cell_synapse');
SELECT columns_are(
  'link_distal_cell_synapse',
  ARRAY['id', 'cell_id', 'synapse_id']
);
SELECT has_pk('link_distal_cell_synapse');
SELECT has_fk('link_distal_cell_synapse');
SELECT has_unique('link_distal_cell_synapse');

SELECT col_type_is('link_distal_cell_synapse', 'id', 'integer');
SELECT col_not_null('link_distal_cell_synapse', 'id');
SELECT col_is_pk('link_distal_cell_synapse', 'id');

SELECT col_type_is('link_distal_cell_synapse', 'cell_id', 'integer');
SELECT col_not_null('link_distal_cell_synapse', 'cell_id');
SELECT col_is_fk('link_distal_cell_synapse', 'cell_id');

SELECT col_type_is('link_distal_cell_synapse', 'synapse_id', 'integer');
SELECT col_not_null('link_distal_cell_synapse', 'synapse_id');
SELECT col_is_fk('link_distal_cell_synapse', 'synapse_id');

SELECT col_is_unique('link_distal_cell_synapse', ARRAY[
  'cell_id',
  'synapse_id'
]);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

