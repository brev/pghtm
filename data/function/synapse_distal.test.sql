/**
 * Synapse (Distal) Function Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(9);  -- Test count


-- test synapse_distal_get_connection()
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


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

