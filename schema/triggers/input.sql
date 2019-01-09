/**
 * Input/SDR Triggers
 */


/**
 * Auto-update htm.column.overlap_duty_cycle, after overlap scores are updated,
 *  after new input.
 */
CREATE TRIGGER trigger_input_column_overlap_duty_cycle_change
  AFTER INSERT
  ON htm.input
  EXECUTE FUNCTION htm.column_overlap_duty_cycle_update();

/**
 * Auto-update htm.input.modified column/field to NOW() on row update.
 */
CREATE TRIGGER trigger_input_modified_change
  BEFORE UPDATE 
  ON htm.input
  FOR EACH ROW 
    EXECUTE FUNCTION htm.schema_modified_update();

