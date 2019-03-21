/**
 * Synapse (Proximal: Connected) View Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$
    SELECT ROUND((
      (
        SELECT COUNT(spc.id)::NUMERIC
        FROM synapse_proximal_connect AS spc
      ) / (
        SELECT COUNT(sp.id)::NUMERIC
        FROM synapse_proximal AS sp
      )
    ), 1);
  $$,
  ROW(config('synapse_proximal_spread_pct')::NUMERIC),
  'Synapse Proximal:Connect view has valid count total'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

