/**
 * Synapse Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


SELECT has_trigger('synapse', 'trigger_synapse_state_change');

SELECT has_trigger('synapse', 'trigger_synapse_column_overlap_change');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

