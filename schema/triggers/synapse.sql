/**
 * Synapse Triggers
 */


/**
 * Auto-update htm.synapse.state based on next-step threshold calculations.
 */
CREATE TRIGGER trigger_synapse_state_change
  BEFORE INSERT OR UPDATE
  ON htm.synapse
  FOR EACH ROW 
    EXECUTE FUNCTION htm.synapse_state_update();

/**
 * Auto-update htm.column.overlap based on synapse.input changes 
 *  (triggered from input.indexes originally).
 */
CREATE TRIGGER trigger_synapse_column_overlap_change
  AFTER INSERT OR UPDATE
  ON htm.synapse
  EXECUTE FUNCTION htm.column_overlap_update();

