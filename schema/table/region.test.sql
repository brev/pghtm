/**
 * Region Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(26);  -- Test count


SELECT has_table('region');
SELECT columns_are('region', ARRAY[
  'id',
  'created',
  'duty_cycle_active_mean',
  'duty_cycle_overlap_mean',
  'modified'
]);
SELECT has_pk('region');
SELECT has_check('region');

SELECT col_type_is('region', 'id', 'integer');
SELECT col_not_null('region', 'id');
SELECT col_is_pk('region', 'id');
SELECT col_has_check('region', 'id');

SELECT col_type_is('region', 'created', 'timestamp with time zone');
SELECT col_not_null('region', 'created');
SELECT col_has_default('region', 'created');
SELECT col_default_is('region', 'created', 'now()');

SELECT col_type_is('region', 'duty_cycle_active_mean', 'numeric');
SELECT col_not_null('region', 'duty_cycle_active_mean');
SELECT col_has_check('region', 'duty_cycle_active_mean');
SELECT col_has_default('region', 'duty_cycle_active_mean');
SELECT col_default_is('region', 'duty_cycle_active_mean', 0.0);

SELECT col_type_is('region', 'duty_cycle_overlap_mean', 'numeric');
SELECT col_not_null('region', 'duty_cycle_overlap_mean');
SELECT col_has_check('region', 'duty_cycle_overlap_mean');
SELECT col_has_default('region', 'duty_cycle_overlap_mean');
SELECT col_default_is('region', 'duty_cycle_overlap_mean', 0.0);

SELECT col_type_is('region', 'modified', 'timestamp with time zone');
SELECT col_not_null('region', 'modified');
SELECT col_has_default('region', 'modified');
SELECT col_default_is('region', 'modified', 'now()');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

