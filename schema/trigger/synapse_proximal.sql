/**
 * Synapse (Proximal) Triggers
 */


/**
 * Auto-update synapse_proximal.modified field to NOW() on row update.
 */
CREATE TRIGGER trigger_synapse_proximal_modified_change
  BEFORE UPDATE
  ON htm.synapse_proximal
  FOR EACH ROW
    EXECUTE FUNCTION htm.schema_modified_update();

