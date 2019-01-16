/**
 * Variables Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(27);  -- Test count


SELECT has_table('variable');
SELECT columns_are('variable', ARRAY[
  'id',
  'boost_strength',
  'dendrite_threshold',
  'duty_cycle_period',
  'inhibition',
  'logging',
  'sp_learn',
  'synapse_decrement',
  'synapse_increment',
  'synapse_threshold'
]);
SELECT has_pk('variable');

SELECT col_type_is('variable', 'id', 'integer');
SELECT col_not_null('variable', 'id');
SELECT col_is_pk('variable', 'id');
SELECT col_has_default('variable', 'id');
SELECT col_default_is('variable', 'id', 1);
SELECT col_has_check('variable', 'id');

SELECT col_type_is('variable', 'boost_strength', 'numeric');
SELECT col_not_null('variable', 'boost_strength');

SELECT col_type_is('variable', 'dendrite_threshold', 'integer');
SELECT col_not_null('variable', 'dendrite_threshold');

SELECT col_type_is('variable', 'duty_cycle_period', 'integer');
SELECT col_not_null('variable', 'duty_cycle_period');

SELECT col_type_is('variable', 'inhibition', 'integer');
SELECT col_not_null('variable', 'inhibition');

SELECT col_type_is('variable', 'logging', 'boolean');
SELECT col_not_null('variable', 'logging');

SELECT col_type_is('variable', 'sp_learn', 'integer');
SELECT col_not_null('variable', 'sp_learn');

SELECT col_type_is('variable', 'synapse_decrement', 'numeric');
SELECT col_not_null('variable', 'synapse_decrement');

SELECT col_type_is('variable', 'synapse_increment', 'numeric');
SELECT col_not_null('variable', 'synapse_increment');

SELECT col_type_is('variable', 'synapse_threshold', 'numeric');
SELECT col_not_null('variable', 'synapse_threshold');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

