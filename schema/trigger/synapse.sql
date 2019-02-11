/**
 * Synapse Triggers
 */


/**
 * Auto-update htm.synapse.modified column/field to NOW() on row update.
 */
CREATE TRIGGER trigger_synapse_modified_change
  BEFORE UPDATE
  ON htm.synapse
  FOR EACH ROW
    EXECUTE FUNCTION htm.schema_modified_update();

