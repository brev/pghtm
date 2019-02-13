/**
 * Synapse (Distal) Triggers
 */


/**
 * Auto-update synapse_distal.modified field to NOW() on row update.
 */
CREATE TRIGGER trigger_synapse_distal_modified_change
  BEFORE UPDATE
  ON htm.synapse_distal
  FOR EACH ROW
    EXECUTE FUNCTION htm.schema_modified_update();

