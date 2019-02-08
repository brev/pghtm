/**
 * Link (Distal: Cell > Synapse) Trigger Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT has_trigger(
  'link_distal_cell_synapse',
  'trigger_link_distal_cell_synapse_segment_unique_change'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

