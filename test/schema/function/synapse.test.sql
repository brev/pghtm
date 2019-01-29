/**
 * Synapse Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(51);  -- Test count


-- test synapse_distal_get_connection()
SELECT has_function('synapse_distal_get_connection', ARRAY['numeric']);
SELECT function_lang_is('synapse_distal_get_connection', 'plpgsql');
SELECT volatility_is('synapse_distal_get_connection', 'stable');
SELECT function_returns('synapse_distal_get_connection', 'boolean');
SELECT is(
  synapse_distal_get_connection(0.00),
  false,
  'synapse_distal_get_connection() works min'
);
SELECT is(
  synapse_distal_get_connection(
    config('synapse_distal_threshold')::NUMERIC -
    config('synapse_distal_decrement')::NUMERIC
  ),
  false,
  'synapse_distal_get_connection() false under threshold'
);
SELECT is(
  synapse_distal_get_connection(
    config('synapse_distal_threshold')::NUMERIC
  ),
  false,
  'synapse_distal_get_connection() false on threshold'
);
SELECT is(
  synapse_distal_get_connection(
    config('synapse_distal_threshold')::NUMERIC +
    config('synapse_distal_increment')::NUMERIC
  ),
  true,
  'synapse_distal_get_connection() true beyond threshold'
);
SELECT is(
  synapse_distal_get_connection(1.00),
  true,
  'synapse_distal_get_connection() works max'
);

-- test synapse_distal_get_decrement()
SELECT has_function('synapse_distal_get_decrement', ARRAY['numeric']);
SELECT function_lang_is('synapse_distal_get_decrement', 'plpgsql');
SELECT volatility_is('synapse_distal_get_decrement', 'stable');
SELECT function_returns('synapse_distal_get_decrement', 'numeric');
SELECT is(
  synapse_distal_get_decrement(0.00001),
  0.0,
  'synapse_distal_get_decrement() unlearns down to min 0.0'
);
SELECT cmp_ok(
  synapse_distal_get_decrement(0.11),
  '<',
  0.11,
  'synapse_distal_get_decrement() unlearns down below threshold'
);

-- test synapse_distal_get_increment()
SELECT has_function('synapse_distal_get_increment', ARRAY['numeric']);
SELECT function_lang_is('synapse_distal_get_increment', 'plpgsql');
SELECT volatility_is('synapse_distal_get_increment', 'stable');
SELECT function_returns('synapse_distal_get_increment', 'numeric');
SELECT cmp_ok(
  synapse_distal_get_increment(0.88),
  '>',
  0.88,
  'synapse_distal_get_increment() learns up above threshold'
);
SELECT is(
  synapse_distal_get_increment(0.99999),
  1.0,
  'synapse_distal_get_increment() learns up to max 1.0'
);

-- test synapse_proximal_boost_update()
SELECT has_function('synapse_proximal_boost_update');
SELECT function_lang_is('synapse_proximal_boost_update', 'plpgsql');
SELECT function_returns('synapse_proximal_boost_update', 'trigger');

-- test synapse_proximal_get_connection()
SELECT has_function('synapse_proximal_get_connection', ARRAY['numeric']);
SELECT function_lang_is('synapse_proximal_get_connection', 'plpgsql');
SELECT volatility_is('synapse_proximal_get_connection', 'stable');
SELECT function_returns('synapse_proximal_get_connection', 'boolean');
SELECT is(
  synapse_proximal_get_connection(0.00),
  false,
  'synapse_proximal_get_connection() works min'
);
SELECT is(
  synapse_proximal_get_connection(
    config('synapse_proximal_threshold')::NUMERIC -
    config('synapse_proximal_decrement')::NUMERIC
  ),
  false,
  'synapse_proximal_get_connection() false under threshold'
);
SELECT is(
  synapse_proximal_get_connection(
    config('synapse_proximal_threshold')::NUMERIC
  ),
  false,
  'synapse_proximal_get_connection() false on threshold'
);
SELECT is(
  synapse_proximal_get_connection(
    config('synapse_proximal_threshold')::NUMERIC +
    config('synapse_proximal_increment')::NUMERIC
  ),
  true,
  'synapse_proximal_get_connection() true beyond threshold'
);
SELECT is(
  synapse_proximal_get_connection(1.00),
  true,
  'synapse_proximal_get_connection() works max'
);

-- test synapse_proximal_get_decrement()
SELECT has_function('synapse_proximal_get_decrement', ARRAY['numeric']);
SELECT function_lang_is('synapse_proximal_get_decrement', 'plpgsql');
SELECT volatility_is('synapse_proximal_get_decrement', 'stable');
SELECT function_returns('synapse_proximal_get_decrement', 'numeric');
SELECT is(
  synapse_proximal_get_decrement(0.00001),
  0.0,
  'synapse_proximal_get_decrement() unlearns down to min 0.0'
);
SELECT cmp_ok(
  synapse_proximal_get_decrement(0.11),
  '<',
  0.11,
  'synapse_proximal_get_decrement() unlearns down below threshold'
);

-- test synapse_proximal_get_increment()
SELECT has_function('synapse_proximal_get_increment', ARRAY['numeric']);
SELECT function_lang_is('synapse_proximal_get_increment', 'plpgsql');
SELECT volatility_is('synapse_proximal_get_increment', 'stable');
SELECT function_returns('synapse_proximal_get_increment', 'numeric');
SELECT cmp_ok(
  synapse_proximal_get_increment(0.88),
  '>',
  0.88,
  'synapse_proximal_get_increment() learns up above threshold'
);
SELECT is(
  synapse_proximal_get_increment(0.99999),
  1.0,
  'synapse_proximal_get_increment() learns up to max 1.0'
);

-- test synapse_distal_learn_update()
SELECT has_function('synapse_distal_learn_update');
SELECT function_lang_is('synapse_distal_learn_update', 'plpgsql');
SELECT function_returns('synapse_distal_learn_update', 'trigger');

-- test synapse_proximal_learn_update()
SELECT has_function('synapse_proximal_learn_update');
SELECT function_lang_is('synapse_proximal_learn_update', 'plpgsql');
SELECT function_returns('synapse_proximal_learn_update', 'trigger');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

