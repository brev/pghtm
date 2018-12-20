/**
 * Synapse (Connected) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(4);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM synapse_connected; $$,
  ROW(0::bigint),
  'Synapse_Connected starts empty'
);

UPDATE synapse 
  SET permanence = (config_numeric('ThresholdSynapsePermanence') - 0.10)
  WHERE id = 1;
SELECT row_eq(
  $$ SELECT COUNT(id) FROM synapse_connected; $$,
  ROW(0::bigint),
  'Synapse_Connected stays empty when permanence is low'
);

UPDATE synapse 
  SET permanence = config_numeric('ThresholdSynapsePermanence')
  WHERE id = 1;
SELECT row_eq(
  $$ SELECT COUNT(id) FROM synapse_connected; $$,
  ROW(1::bigint),
  'Synapse_Connected becomes connected when permanence hits threshold'
);

UPDATE synapse 
  SET permanence = 1.00 
  WHERE id = 1;
SELECT row_eq(
  $$ SELECT COUNT(id) FROM synapse_connected; $$,
  ROW(1::bigint),
  'Synapse_Connected stays connected when permanence maxxed'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

