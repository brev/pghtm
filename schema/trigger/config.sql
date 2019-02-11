/**
 * Config Triggers
 */


/**
 * When the config table is updated, call config_generate() again to recreate
 *  the config() cached static getter function.
 */
CREATE TRIGGER trigger_config_regenerate_change
  AFTER INSERT OR UPDATE
  ON htm.config
  EXECUTE FUNCTION htm.config_regenerate_update();

/**
 * Auto-update htm.config.modified column/field to NOW() on row update.
 */
CREATE TRIGGER trigger_config_modified_change
  BEFORE UPDATE
  ON htm.config
  FOR EACH ROW
    EXECUTE FUNCTION htm.schema_modified_update();

