/**
 * Synapse (Proximal) Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(27);  -- Test count


SELECT has_table('synapse_proximal');
SELECT columns_are('synapse_proximal', ARRAY[
  'id',
  'column_id',
  'created',
  'input_index',
  'modified',
  'permanence'
]);
SELECT has_pk('synapse_proximal');
SELECT has_fk('synapse_proximal');
SELECT has_check('synapse_proximal');
SELECT has_unique('synapse_proximal');

SELECT col_type_is('synapse_proximal', 'id', 'integer');
SELECT col_not_null('synapse_proximal', 'id');
SELECT col_is_pk('synapse_proximal', 'id');
SELECT col_has_check('synapse_proximal', 'id');

SELECT col_type_is('synapse_proximal', 'column_id', 'integer');
SELECT col_not_null('synapse_proximal', 'column_id');
SELECT col_is_fk('synapse_proximal', 'column_id');

SELECT col_type_is('synapse_proximal', 'created', 'timestamp with time zone');
SELECT col_not_null('synapse_proximal', 'created');
SELECT col_has_default('synapse_proximal', 'created');
SELECT col_default_is('synapse_proximal', 'created', 'now()');

SELECT col_type_is('synapse_proximal', 'input_index', 'integer');
SELECT col_not_null('synapse_proximal', 'input_index');

SELECT col_type_is('synapse_proximal', 'modified', 'timestamp with time zone');
SELECT col_not_null('synapse_proximal', 'modified');
SELECT col_has_default('synapse_proximal', 'modified');
SELECT col_default_is('synapse_proximal', 'modified', 'now()');

SELECT col_type_is('synapse_proximal', 'permanence', 'numeric');
SELECT col_not_null('synapse_proximal', 'permanence');
SELECT col_has_check('synapse_proximal', 'permanence');

SELECT col_is_unique('synapse_proximal', ARRAY['column_id', 'input_index']);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

