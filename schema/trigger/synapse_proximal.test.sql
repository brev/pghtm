/**
 * Synapse (Proximal) Trigger Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT has_trigger(
  'synapse_proximal',
  'trigger_synapse_proximal_modified_change'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

