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

