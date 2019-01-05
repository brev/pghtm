/**
 * Input/SDR Triggers
 */


/**
 * Auto-update htm.input.modified column/field to NOW() on row update.
 */
CREATE TRIGGER update_input_modified
  BEFORE UPDATE 
  ON htm.input
  FOR EACH ROW 
    EXECUTE PROCEDURE htm.update_field_modified();

