/**
 * Synapse (Distal) Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(28);  -- Test count


SELECT has_table('synapse_distal');
SELECT columns_are('synapse_distal', ARRAY[
  'id',
  'created',
  'input_cell_id',
  'modified',
  'permanence',
  'segment_id'
]);
SELECT has_pk('synapse_distal');
SELECT has_check('synapse_distal');
SELECT has_fk('synapse_distal');
SELECT has_unique('synapse_distal');

SELECT col_type_is('synapse_distal', 'id', 'integer');
SELECT col_not_null('synapse_distal', 'id');
SELECT col_is_pk('synapse_distal', 'id');
SELECT col_has_check('synapse_distal', 'id');

SELECT col_type_is('synapse_distal', 'created', 'timestamp with time zone');
SELECT col_not_null('synapse_distal', 'created');
SELECT col_has_default('synapse_distal', 'created');
SELECT col_default_is('synapse_distal', 'created', 'now()');

SELECT col_type_is('synapse_distal', 'input_cell_id', 'integer');
SELECT col_not_null('synapse_distal', 'input_cell_id');
SELECT col_is_fk('synapse_distal', 'input_cell_id');

SELECT col_type_is('synapse_distal', 'modified', 'timestamp with time zone');
SELECT col_not_null('synapse_distal', 'modified');
SELECT col_has_default('synapse_distal', 'modified');
SELECT col_default_is('synapse_distal', 'modified', 'now()');

SELECT col_type_is('synapse_distal', 'permanence', 'numeric');
SELECT col_not_null('synapse_distal', 'permanence');
SELECT col_has_check('synapse_distal', 'permanence');

SELECT col_type_is('synapse_distal', 'segment_id', 'integer');
SELECT col_not_null('synapse_distal', 'segment_id');
SELECT col_is_fk('synapse_distal', 'segment_id');

SELECT col_is_unique('synapse_distal', ARRAY['input_cell_id', 'segment_id']);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

