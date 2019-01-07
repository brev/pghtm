/**
 * Synapse Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT has_trigger('synapse', 'trigger_synapse_state_change');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

