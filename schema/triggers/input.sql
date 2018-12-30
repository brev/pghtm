/**
 * Input/SDR Triggers
 */


/**
 * Auto-update htm.input.modified column to NOW() on row update.
 */
CREATE TRIGGER update_modified_input 
  BEFORE UPDATE 
  ON htm.input
  FOR EACH ROW 
    EXECUTE PROCEDURE htm.update_modified_column();

