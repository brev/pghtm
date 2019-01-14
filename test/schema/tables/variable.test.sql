/**
 * Variables Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(25);  -- Test count


SELECT has_table('variable');
SELECT columns_are('variable', ARRAY[
  'id',
  'booststrength',
  'dendritethreshold',
  'dutycycleperiod',
  'inhibition',
  'splearn',
  'synapsedecrement',
  'synapseincrement',
  'synapsethreshold'
]);
SELECT has_pk('variable');

SELECT col_type_is('variable', 'id', 'integer');
SELECT col_not_null('variable', 'id');
SELECT col_is_pk('variable', 'id');
SELECT col_has_default('variable', 'id');
SELECT col_default_is('variable', 'id', 1);
SELECT col_has_check('variable', 'id');

SELECT col_type_is('variable', 'booststrength', 'numeric');
SELECT col_not_null('variable', 'booststrength');

SELECT col_type_is('variable', 'dendritethreshold', 'integer');
SELECT col_not_null('variable', 'dendritethreshold');

SELECT col_type_is('variable', 'dutycycleperiod', 'integer');
SELECT col_not_null('variable', 'dutycycleperiod');

SELECT col_type_is('variable', 'inhibition', 'integer');
SELECT col_not_null('variable', 'inhibition');

SELECT col_type_is('variable', 'splearn', 'integer');
SELECT col_not_null('variable', 'splearn');

SELECT col_type_is('variable', 'synapsedecrement', 'numeric');
SELECT col_not_null('variable', 'synapsedecrement');

SELECT col_type_is('variable', 'synapseincrement', 'numeric');
SELECT col_not_null('variable', 'synapseincrement');

SELECT col_type_is('variable', 'synapsethreshold', 'numeric');
SELECT col_not_null('variable', 'synapsethreshold');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

