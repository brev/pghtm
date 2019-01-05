/**
 * Synapse Triggers
 */


/**
 * Auto-update htm.synapse.state based on next-step threshold calculations.
 */
CREATE TRIGGER update_synapse_state
  BEFORE INSERT OR UPDATE 
  ON htm.synapse
  FOR EACH ROW 
    EXECUTE PROCEDURE htm.synapse_update_field_state();

