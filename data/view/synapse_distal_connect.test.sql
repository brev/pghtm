/**
 * Synapse (Distal: Connected) View Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM synapse_distal_connect $$,
  ROW(0::BIGINT),
  'Synapse Distal:Connect view has valid count total'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

