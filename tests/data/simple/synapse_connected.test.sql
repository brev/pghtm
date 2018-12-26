/**
 * Synapse (Connected) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(5);  -- Test count


UPDATE synapse
  SET permanence = 0.00;
SELECT row_eq(
  $$ SELECT COUNT(id) FROM synapse_connected; $$,
  ROW(0::BIGINT),
  'Synapse_Connected starts unconnected'
);

UPDATE synapse 
  SET permanence = (
    config('ThresholdSynapse')::NUMERIC - 
    config('SynapseDecrement')::NUMERIC
  )
  WHERE id = 1;
SELECT row_eq(
  $$ SELECT COUNT(id) FROM synapse_connected; $$,
  ROW(0::BIGINT),
  'Synapse_Connected stays unconnected when permanence is low'
);

UPDATE synapse 
  SET permanence = config('ThresholdSynapse')::NUMERIC
  WHERE id = 1;
SELECT row_eq(
  $$ SELECT COUNT(id) FROM synapse_connected; $$,
  ROW(0::BIGINT),
  'Synapse_Connected stays unconnected when permanence hits threshold'
);

UPDATE synapse 
  SET permanence = (
    config('ThresholdSynapse')::NUMERIC + 
    config('SynapseIncrement')::NUMERIC
  )
  WHERE id = 1;
SELECT row_eq(
  $$ SELECT COUNT(id) FROM synapse_connected; $$,
  ROW(1::BIGINT),
  'Synapse_Connected becomes connected when permanence crosses threshold'
);

UPDATE synapse 
  SET permanence = 1.00 
  WHERE id = 1;
SELECT row_eq(
  $$ SELECT COUNT(id) FROM synapse_connected; $$,
  ROW(1::BIGINT),
  'Synapse_Connected stays connected when permanence is maxxed'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

