/**
 * Cell Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(30);  -- Test count


SELECT has_table('cell');
SELECT columns_are('cell', ARRAY[
  'id',
  'active',
  'active_last',
  'column_id',
  'created',
  'modified',
  'y_coord'
]);
SELECT has_pk('cell');
SELECT has_fk('cell');
SELECT has_check('cell');

SELECT col_type_is('cell', 'id', 'integer');
SELECT col_not_null('cell', 'id');
SELECT col_is_pk('cell', 'id');
SELECT col_has_check('cell', 'id');

SELECT col_type_is('cell', 'active', 'boolean');
SELECT col_not_null('cell', 'active');
SELECT col_has_default('cell', 'active');
SELECT col_default_is('cell', 'active', false);

SELECT col_type_is('cell', 'active_last', 'boolean');
SELECT col_not_null('cell', 'active_last');
SELECT col_has_default('cell', 'active_last');
SELECT col_default_is('cell', 'active_last', false);

SELECT col_type_is('cell', 'column_id', 'integer');
SELECT col_not_null('cell', 'column_id');
SELECT col_is_fk('cell', 'column_id');

SELECT col_type_is('cell', 'created', 'timestamp with time zone');
SELECT col_not_null('cell', 'created');
SELECT col_has_default('cell', 'created');
SELECT col_default_is('cell', 'created', 'now()');

SELECT col_type_is('cell', 'modified', 'timestamp with time zone');
SELECT col_not_null('cell', 'modified');
SELECT col_has_default('cell', 'modified');
SELECT col_default_is('cell', 'modified', 'now()');

SELECT col_type_is('cell', 'y_coord', 'integer');
SELECT col_not_null('cell', 'y_coord');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

