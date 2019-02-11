/**
 * Region Triggers
 */


/**
 * Auto-update htm.region.modified column/field to NOW() on row update.
 */
CREATE TRIGGER trigger_region_modified_change
  BEFORE UPDATE
  ON htm.region
  FOR EACH ROW
    EXECUTE FUNCTION htm.schema_modified_update();

