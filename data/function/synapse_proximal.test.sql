/**
 * Synapse (Proximal) Function Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(9);  -- Test count


-- test synapse_proximal_get_connection()
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


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

