/**
 * Config Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(86);  -- Test count


SELECT has_table('config');
SELECT columns_are('config', ARRAY[
  'id',

  -- constants
  'column_count',
  'dendrite_count',
  'input_width',
  'neuron_count',
  'row_count',
  'synapse_count',
  'synapse_distal_spread_pct',
  'synapse_proximal_spread_pct',

  -- variables
  'column_active_limit',
  'column_boost_strength',
  'column_duty_cycle_period',
  'column_inhibit',
  'debug',
  'dendrite_synapse_threshold',
  'neuron_dendrite_threshold',
  'synapse_distal_learn',
  'synapse_distal_decrement',
  'synapse_distal_increment',
  'synapse_distal_threshold',
  'synapse_proximal_learn',
  'synapse_proximal_decrement',
  'synapse_proximal_increment',
  'synapse_proximal_threshold'
]);
SELECT has_pk('config');

SELECT col_type_is('config', 'id', 'integer');
SELECT col_not_null('config', 'id');
SELECT col_is_pk('config', 'id');
SELECT col_has_default('config', 'id');
SELECT col_default_is('config', 'id', 1);
SELECT col_has_check('config', 'id');


-- constants

SELECT col_type_is('config', 'column_count', 'integer');
SELECT col_not_null('config', 'column_count');
SELECT col_has_default('config', 'column_count');
SELECT col_has_check('config', 'column_count');

SELECT col_type_is('config', 'dendrite_count', 'integer');
SELECT col_not_null('config', 'dendrite_count');
SELECT col_has_default('config', 'dendrite_count');
SELECT col_has_check('config', 'dendrite_count');

SELECT col_type_is('config', 'input_width', 'integer');
SELECT col_not_null('config', 'input_width');
SELECT col_has_default('config', 'input_width');
SELECT col_has_check('config', 'input_width');

SELECT col_type_is('config', 'neuron_count', 'integer');
SELECT col_not_null('config', 'neuron_count');
SELECT col_has_default('config', 'neuron_count');
SELECT col_has_check('config', 'neuron_count');

SELECT col_type_is('config', 'row_count', 'integer');
SELECT col_not_null('config', 'row_count');
SELECT col_has_default('config', 'row_count');
SELECT col_has_check('config', 'row_count');

SELECT col_type_is('config', 'synapse_count', 'integer');
SELECT col_not_null('config', 'synapse_count');
SELECT col_has_default('config', 'synapse_count');
SELECT col_has_check('config', 'synapse_count');

SELECT col_type_is('config', 'synapse_distal_spread_pct', 'numeric');
SELECT col_not_null('config', 'synapse_distal_spread_pct');
SELECT col_has_default('config', 'synapse_distal_spread_pct');
SELECT col_has_check('config', 'synapse_distal_spread_pct');

SELECT col_type_is('config', 'synapse_proximal_spread_pct', 'numeric');
SELECT col_not_null('config', 'synapse_proximal_spread_pct');
SELECT col_has_default('config', 'synapse_proximal_spread_pct');
SELECT col_has_check('config', 'synapse_proximal_spread_pct');


-- variables

SELECT col_type_is('config', 'column_active_limit', 'integer');
SELECT col_not_null('config', 'column_active_limit');
SELECT col_has_default('config', 'column_active_limit');

SELECT col_type_is('config', 'column_boost_strength', 'numeric');
SELECT col_not_null('config', 'column_boost_strength');
SELECT col_has_default('config', 'column_boost_strength');

SELECT col_type_is('config', 'column_duty_cycle_period', 'integer');
SELECT col_not_null('config', 'column_duty_cycle_period');
SELECT col_has_default('config', 'column_duty_cycle_period');

SELECT col_type_is('config', 'column_inhibit', 'boolean');
SELECT col_not_null('config', 'column_inhibit');
SELECT col_has_default('config', 'column_inhibit');

SELECT col_type_is('config', 'debug', 'boolean');
SELECT col_not_null('config', 'debug');
SELECT col_has_default('config', 'debug');

SELECT col_type_is('config', 'dendrite_synapse_threshold', 'integer');
SELECT col_not_null('config', 'dendrite_synapse_threshold');
SELECT col_has_default('config', 'dendrite_synapse_threshold');

SELECT col_type_is('config', 'neuron_dendrite_threshold', 'integer');
SELECT col_not_null('config', 'neuron_dendrite_threshold');
SELECT col_has_default('config', 'neuron_dendrite_threshold');

SELECT col_type_is('config', 'synapse_distal_learn', 'boolean');
SELECT col_not_null('config', 'synapse_distal_learn');
SELECT col_has_default('config', 'synapse_distal_learn');

SELECT col_type_is('config', 'synapse_distal_decrement', 'numeric');
SELECT col_not_null('config', 'synapse_distal_decrement');
SELECT col_has_default('config', 'synapse_distal_decrement');

SELECT col_type_is('config', 'synapse_distal_increment', 'numeric');
SELECT col_not_null('config', 'synapse_distal_increment');
SELECT col_has_default('config', 'synapse_distal_increment');

SELECT col_type_is('config', 'synapse_distal_threshold', 'numeric');
SELECT col_not_null('config', 'synapse_distal_threshold');
SELECT col_has_default('config', 'synapse_distal_threshold');

SELECT col_type_is('config', 'synapse_proximal_learn', 'boolean');
SELECT col_not_null('config', 'synapse_proximal_learn');
SELECT col_has_default('config', 'synapse_proximal_learn');

SELECT col_type_is('config', 'synapse_proximal_decrement', 'numeric');
SELECT col_not_null('config', 'synapse_proximal_decrement');
SELECT col_has_default('config', 'synapse_proximal_decrement');

SELECT col_type_is('config', 'synapse_proximal_increment', 'numeric');
SELECT col_not_null('config', 'synapse_proximal_increment');
SELECT col_has_default('config', 'synapse_proximal_increment');

SELECT col_type_is('config', 'synapse_proximal_threshold', 'numeric');
SELECT col_not_null('config', 'synapse_proximal_threshold');
SELECT col_has_default('config', 'synapse_proximal_threshold');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

