/**
 * Synapse (Connected) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ 
    SELECT ROUND((
      (SELECT COUNT(id)::NUMERIC FROM synapse_connected) / 
      (SELECT COUNT(id)::NUMERIC FROM synapse)
    ), 1);
  $$, 
  ROW(const('potentialPct')::NUMERIC), 
  'Synapse Connected view has valid count total'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

