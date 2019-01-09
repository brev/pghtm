/**
 * Column Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(14);  -- Test count


SELECT has_table('column');
SELECT columns_are(
  'column', 
  ARRAY[
    'id', 
    'region_id', 
    'x_coord',
    'overlap_duty_cycle'
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

SELECT col_type_is('column', 'overlap_duty_cycle', 'numeric');
SELECT col_not_null('column', 'overlap_duty_cycle');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

