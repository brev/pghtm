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

