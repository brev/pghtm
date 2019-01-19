/**
 * Synapse (Proximal: Connected) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$
    SELECT ROUND((
      (SELECT COUNT(id)::NUMERIC FROM synapse_proximal_connected) /
      (
        SELECT COUNT(synapse.id)::NUMERIC
        FROM synapse
        JOIN dendrite
          ON dendrite.id = synapse.dendrite_id
          AND dendrite.class = 'proximal'
      )
    ), 1);
  $$,
  ROW(config('synapse_proximal_spread_pct')::NUMERIC),
  'Synapse Proximal:Connected view has valid count total'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

