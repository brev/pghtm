/**
 * Neuron Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(16);  -- Test count


SELECT has_table('neuron');
SELECT columns_are('neuron', ARRAY['id', 'column_id', 'y_coord', 'active']);
SELECT has_pk('neuron');
SELECT has_fk('neuron');

SELECT col_type_is('neuron', 'id', 'integer');
SELECT col_not_null('neuron', 'id');
SELECT col_is_pk('neuron', 'id');

SELECT col_type_is('neuron', 'column_id', 'integer');
SELECT col_not_null('neuron', 'column_id');
SELECT col_is_fk('neuron', 'column_id');

SELECT col_type_is('neuron', 'y_coord', 'integer');
SELECT col_not_null('neuron', 'y_coord');

SELECT col_type_is('neuron', 'active', 'boolean');
SELECT col_not_null('neuron', 'active');
SELECT col_has_default('neuron', 'active');
SELECT col_default_is('neuron', 'active', false);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

