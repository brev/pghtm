/**
 * Neuron Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(11);  -- Test count


-- test neuron_active_update()
SELECT has_function('neuron_active_update');
SELECT function_lang_is('neuron_active_update', 'plpgsql');
SELECT function_returns('neuron_active_update', 'trigger');

-- test neuron_is_predict()
SELECT has_function('neuron_is_predict', ARRAY['integer']);
SELECT function_lang_is('neuron_is_predict', 'plpgsql');
SELECT volatility_is('neuron_is_predict', 'stable');
SELECT function_returns('neuron_is_predict', 'boolean');
SELECT is(
  neuron_is_predict(0),
  FALSE,
  'neuron_is_predict() works min'
);
SELECT is(
  neuron_is_predict(config('neuron_dendrite_threshold')::INT),
  FALSE,
  'neuron_is_predict() false on threshold'
);
SELECT is(
  neuron_is_predict(config('neuron_dendrite_threshold')::INT + 1),
  TRUE,
  'neuron_is_predict() true beyond threshold'
);
SELECT is(
  neuron_is_predict(config('dendrite_count')::INT),
  TRUE,
  'neuron_is_predict() true at max'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

