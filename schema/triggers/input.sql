/**
 * Input/SDR Triggers
 */


/**
 * Auto-update htm.input.modified column/field to NOW() on row update.
 */
CREATE TRIGGER trigger_input_modified_change
  BEFORE UPDATE 
  ON htm.input
  FOR EACH ROW 
    EXECUTE PROCEDURE htm.schema_modified_update();

/**
 * Update synapses connected to newly inserted inputs to be active.
 */
CREATE TRIGGER trigger_input_synapse_input_change
  AFTER INSERT 
  ON htm.input
  FOR EACH ROW 
    EXECUTE PROCEDURE htm.synapse_input_update();

