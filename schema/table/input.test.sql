/**
 * Input Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(24);  -- Test count


SELECT has_table('input');
SELECT columns_are('input', ARRAY[
  'id',
  'columns_active',
  'columns_predict',
  'created',
  'indexes',
  'modified',
  'ts'
]);
SELECT has_pk('input');
SELECT has_check('input');

SELECT col_type_is('input', 'id', 'integer');
SELECT col_not_null('input', 'id');
SELECT col_is_pk('input', 'id');
SELECT col_has_check('input', 'id');

SELECT col_type_is('input', 'created', 'timestamp with time zone');
SELECT col_not_null('input', 'created');
SELECT col_has_default('input', 'created');
SELECT col_default_is('input', 'created', 'now()');

SELECT col_type_is('input', 'modified', 'timestamp with time zone');
SELECT col_not_null('input', 'modified');
SELECT col_has_default('input', 'modified');
SELECT col_default_is('input', 'modified', 'now()');

SELECT col_type_is('input', 'ts', 'timestamp with time zone');
SELECT col_not_null('input', 'ts');
SELECT col_has_default('input', 'ts');
SELECT col_default_is('input', 'ts', 'now()');

SELECT col_type_is('input', 'indexes', 'integer[]');
SELECT col_not_null('input', 'indexes');

SELECT col_type_is('input', 'columns_active', 'integer[]');

SELECT col_type_is('input', 'columns_predict', 'integer[]');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

