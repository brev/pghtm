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
 * Auto-update htm.dendrite.state based on htm.synapse.state changes.
 */
CREATE TRIGGER trigger_synapse_dendrite_state_change
  AFTER INSERT OR UPDATE
  ON htm.synapse
  EXECUTE FUNCTION htm.dendrite_state_update();

