/**
 * Link Input to Synapse Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(16);  -- Test count


SELECT has_table('link_proximal_input_synapse');
SELECT columns_are('link_proximal_input_synapse', ARRAY[
  'id',
  'created',
  'input_index',
  'synapse_id'
]);
SELECT has_pk('link_proximal_input_synapse');
SELECT has_fk('link_proximal_input_synapse');
SELECT has_unique('link_proximal_input_synapse');
SELECT has_check('link_proximal_input_synapse');

SELECT col_type_is('link_proximal_input_synapse', 'id', 'integer');
SELECT col_not_null('link_proximal_input_synapse', 'id');
SELECT col_is_pk('link_proximal_input_synapse', 'id');
SELECT col_has_check('link_proximal_input_synapse', 'id');

SELECT col_type_is('link_proximal_input_synapse', 'input_index', 'integer');
SELECT col_not_null('link_proximal_input_synapse', 'input_index');

SELECT col_type_is('link_proximal_input_synapse', 'synapse_id', 'integer');
SELECT col_not_null('link_proximal_input_synapse', 'synapse_id');
SELECT col_is_fk('link_proximal_input_synapse', 'synapse_id');

SELECT col_is_unique('link_proximal_input_synapse', ARRAY[
  'input_index',
  'synapse_id'
]);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

