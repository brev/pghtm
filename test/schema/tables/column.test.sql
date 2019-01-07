/**
 * Column Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(17);  -- Test count


SELECT has_table('column');
SELECT columns_are(
  'column', 
  ARRAY[
    'id', 
    'region_id', 
    'x_coord', 
    'overlap',
    'overlapdutycycle'
  ]
);
SELECT has_pk('column');
SELECT has_fk('column');

SELECT col_type_is('column', 'id', 'integer');
SELECT col_not_null('column', 'id');
SELECT col_is_pk('column', 'id');

SELECT col_type_is('column', 'region_id', 'integer');
SELECT col_not_null('column', 'region_id');
SELECT col_is_fk('column', 'region_id');

SELECT col_type_is('column', 'x_coord', 'integer');
SELECT col_not_null('column', 'x_coord');

SELECT col_type_is('column', 'overlap', 'integer');
SELECT col_not_null('column', 'overlap');

SELECT col_type_is('column', 'overlapdutycycle', 'numeric');
SELECT col_not_null('column', 'overlapdutycycle');
SELECT col_has_check('column', 'overlapdutycycle');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

