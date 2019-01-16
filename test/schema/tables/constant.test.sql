/**
 * Constants Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(25);  -- Test count


SELECT has_table('constant');
SELECT columns_are('constant', ARRAY[
  'id',
  'column_count',
  'column_threshold',
  'dendrite_count',
  'input_width',
  'neuron_count',
  'potential_pct',
  'row_count',
  'synapse_count'
]);
SELECT has_pk('constant');

SELECT col_type_is('constant', 'id', 'integer');
SELECT col_not_null('constant', 'id');
SELECT col_is_pk('constant', 'id');
SELECT col_has_default('constant', 'id');
SELECT col_default_is('constant', 'id', 1);
SELECT col_has_check('constant', 'id');

SELECT col_type_is('constant', 'column_count', 'integer');
SELECT col_not_null('constant', 'column_count');

SELECT col_type_is('constant', 'column_threshold', 'integer');
SELECT col_not_null('constant', 'column_threshold');

SELECT col_type_is('constant', 'dendrite_count', 'integer');
SELECT col_not_null('constant', 'dendrite_count');

SELECT col_type_is('constant', 'input_width', 'integer');
SELECT col_not_null('constant', 'input_width');

SELECT col_type_is('constant', 'neuron_count', 'integer');
SELECT col_not_null('constant', 'neuron_count');

SELECT col_type_is('constant', 'potential_pct', 'numeric');
SELECT col_not_null('constant', 'potential_pct');

SELECT col_type_is('constant', 'row_count', 'integer');
SELECT col_not_null('constant', 'row_count');

SELECT col_type_is('constant', 'synapse_count', 'integer');
SELECT col_not_null('constant', 'synapse_count');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

