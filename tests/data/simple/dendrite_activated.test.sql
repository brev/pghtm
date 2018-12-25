/**
 * Dendrite (Activated) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(4);  -- Test count


UPDATE synapse 
  SET permanence = 0.00;
SELECT row_eq(
  $$ SELECT COUNT(id) FROM dendrite_activated; $$,
  ROW(0::BIGINT),
  'Dendrite_Activated starts empty'
);

UPDATE synapse 
  SET permanence = 1.00
  WHERE id IN (
    SELECT id
    FROM synapse
    WHERE dendrite_id = 1
    LIMIT (config('ThresholdDendriteSynapse')::INT - 1)
  );
SELECT row_eq(
  $$ SELECT COUNT(id) FROM dendrite_activated; $$,
  ROW(0::BIGINT),
  'Dendrite_Activated stays empty when synapse count is low'
);

UPDATE synapse 
  SET permanence = 1.00
  WHERE id IN (
    SELECT id
    FROM synapse
    WHERE dendrite_id = 1
    LIMIT config('ThresholdDendriteSynapse')::INT
  );
SELECT row_eq(
  $$ SELECT COUNT(id) FROM dendrite_activated; $$,
  ROW(1::BIGINT),
  'Dendrite_Activated fills when synapse count hits threshold'
);

UPDATE synapse 
  SET permanence = 1.00
  WHERE dendrite_id = 1;
SELECT row_eq(
  $$ SELECT COUNT(id) FROM dendrite_activated; $$,
  ROW(1::BIGINT),
  'Dendrite_Activated stays filled when synapse count is maxxed'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

