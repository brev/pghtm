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

