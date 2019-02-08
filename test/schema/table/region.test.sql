/**
 * Region Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(17);  -- Test count


SELECT has_table('region');
SELECT columns_are(
  'region',
  ARRAY [
    'id',
    'duty_cycle_active_mean',
    'duty_cycle_overlap_mean'
  ]
);
SELECT has_pk('region');
SELECT has_check('region');

SELECT col_type_is('region', 'id', 'integer');
SELECT col_not_null('region', 'id');
SELECT col_is_pk('region', 'id');

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


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

