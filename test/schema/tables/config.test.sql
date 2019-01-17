/**
 * Config Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(43);  -- Test count


SELECT has_table('config');
SELECT columns_are('config', ARRAY[
  'id',
  'boost_strength',
  'column_count',
  'column_threshold',
  'dendrite_count',
  'dendrite_threshold',
  'duty_cycle_period',
  'inhibition',
  'input_width',
  'logging',
  'neuron_count',
  'potential_pct',
  'row_count',
  'sp_learn',
  'synapse_count',
  'synapse_decrement',
  'synapse_increment',
  'synapse_threshold'
]);
SELECT has_pk('config');

SELECT col_type_is('config', 'id', 'integer');
SELECT col_not_null('config', 'id');
SELECT col_is_pk('config', 'id');
SELECT col_has_default('config', 'id');
SELECT col_default_is('config', 'id', 1);
SELECT col_has_check('config', 'id');

SELECT col_type_is('config', 'boost_strength', 'numeric');
SELECT col_not_null('config', 'boost_strength');

SELECT col_type_is('config', 'column_count', 'integer');
SELECT col_not_null('config', 'column_count');

SELECT col_type_is('config', 'dendrite_count', 'integer');
SELECT col_not_null('config', 'dendrite_count');

SELECT col_type_is('config', 'column_threshold', 'integer');
SELECT col_not_null('config', 'column_threshold');

SELECT col_type_is('config', 'dendrite_threshold', 'integer');
SELECT col_not_null('config', 'dendrite_threshold');

SELECT col_type_is('config', 'duty_cycle_period', 'integer');
SELECT col_not_null('config', 'duty_cycle_period');

SELECT col_type_is('config', 'inhibition', 'integer');
SELECT col_not_null('config', 'inhibition');

SELECT col_type_is('config', 'input_width', 'integer');
SELECT col_not_null('config', 'input_width');

SELECT col_type_is('config', 'logging', 'boolean');
SELECT col_not_null('config', 'logging');

SELECT col_type_is('config', 'neuron_count', 'integer');
SELECT col_not_null('config', 'neuron_count');

SELECT col_type_is('config', 'potential_pct', 'numeric');
SELECT col_not_null('config', 'potential_pct');

SELECT col_type_is('config', 'row_count', 'integer');
SELECT col_not_null('config', 'row_count');

SELECT col_type_is('config', 'sp_learn', 'boolean');
SELECT col_not_null('config', 'sp_learn');

SELECT col_type_is('config', 'synapse_count', 'integer');
SELECT col_not_null('config', 'synapse_count');

SELECT col_type_is('config', 'synapse_decrement', 'numeric');
SELECT col_not_null('config', 'synapse_decrement');

SELECT col_type_is('config', 'synapse_increment', 'numeric');
SELECT col_not_null('config', 'synapse_increment');

SELECT col_type_is('config', 'synapse_threshold', 'numeric');
SELECT col_not_null('config', 'synapse_threshold');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

