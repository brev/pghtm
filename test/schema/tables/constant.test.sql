/**
 * Constants Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(25);  -- Test count


SELECT has_table('constant');
SELECT columns_are('constant', ARRAY[
  'id',
  'columncount',
  'columnthreshold',
  'dendritecount',
  'inputwidth',
  'neuroncount',
  'potentialpct',
  'rowcount',
  'synapsecount'
]);
SELECT has_pk('constant');

SELECT col_type_is('constant', 'id', 'integer');
SELECT col_not_null('constant', 'id');
SELECT col_is_pk('constant', 'id');
SELECT col_has_default('constant', 'id');
SELECT col_default_is('constant', 'id', 1);
SELECT col_has_check('constant', 'id');

SELECT col_type_is('constant', 'columncount', 'integer');
SELECT col_not_null('constant', 'columncount');

SELECT col_type_is('constant', 'columnthreshold', 'integer');
SELECT col_not_null('constant', 'columnthreshold');

SELECT col_type_is('constant', 'dendritecount', 'integer');
SELECT col_not_null('constant', 'dendritecount');

SELECT col_type_is('constant', 'inputwidth', 'integer');
SELECT col_not_null('constant', 'inputwidth');

SELECT col_type_is('constant', 'neuroncount', 'integer');
SELECT col_not_null('constant', 'neuroncount');

SELECT col_type_is('constant', 'potentialpct', 'numeric');
SELECT col_not_null('constant', 'potentialpct');

SELECT col_type_is('constant', 'rowcount', 'integer');
SELECT col_not_null('constant', 'rowcount');

SELECT col_type_is('constant', 'synapsecount', 'integer');
SELECT col_not_null('constant', 'synapsecount');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

