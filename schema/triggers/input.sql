/**
 * Input/SDR Triggers
 */


/**
 * Auto-update column.boost and column.duty_cycle_(active/overlap), after
 *  new input, using updated views for activity and overlap score calculations.
 * @SpatialPooler
 */
CREATE TRIGGER trigger_input_column_boost_duty_change
  AFTER INSERT
  ON htm.input
  FOR EACH ROW
    EXECUTE FUNCTION htm.column_boost_duty_update();

/**
 * Auto-update htm.input.modified column/field to NOW() on row update.
 */
CREATE TRIGGER trigger_input_modified_change
  BEFORE UPDATE OF columns_active
  ON htm.input
  FOR EACH ROW
    EXECUTE FUNCTION htm.schema_modified_update();

