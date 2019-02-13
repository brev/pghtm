/**
 * Synapse (Distal) Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT has_trigger('synapse_distal', 'trigger_synapse_distal_modified_change');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

