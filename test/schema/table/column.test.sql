/**
 * Column Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(31);  -- Test count


SELECT has_table('column');
SELECT columns_are('column', ARRAY[
  'id',
  'active',
  'boost_factor',
  'duty_cycle_active',
  'duty_cycle_overlap',
  'region_id',
  'x_coord'
]);
SELECT has_pk('column');
SELECT has_fk('column');

SELECT col_type_is('column', 'id', 'integer');
SELECT col_not_null('column', 'id');
SELECT col_is_pk('column', 'id');

SELECT col_type_is('column', 'active', 'boolean');
SELECT col_not_null('column', 'active');
SELECT col_has_default('column', 'active');
SELECT col_default_is('column', 'active', false);

SELECT col_type_is('column', 'boost_factor', 'numeric');
SELECT col_not_null('column', 'boost_factor');
SELECT col_has_check('column', 'boost_factor');
SELECT col_has_default('column', 'boost_factor');
SELECT col_default_is('column', 'boost_factor', 0.0);

SELECT col_type_is('column', 'duty_cycle_active', 'numeric');
SELECT col_not_null('column', 'duty_cycle_active');
SELECT col_has_check('column', 'duty_cycle_active');
SELECT col_has_default('column', 'duty_cycle_active');
SELECT col_default_is('column', 'duty_cycle_active', 1.0);

SELECT col_type_is('column', 'duty_cycle_overlap', 'numeric');
SELECT col_not_null('column', 'duty_cycle_overlap');
SELECT col_has_check('column', 'duty_cycle_overlap');
SELECT col_has_default('column', 'duty_cycle_overlap');
SELECT col_default_is('column', 'duty_cycle_overlap', 1.0);

SELECT col_type_is('column', 'region_id', 'integer');
SELECT col_not_null('column', 'region_id');
SELECT col_is_fk('column', 'region_id');

SELECT col_type_is('column', 'x_coord', 'integer');
SELECT col_not_null('column', 'x_coord');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data
