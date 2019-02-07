/**
 * Input/SDR Triggers
 */


/**
 * When columns are activated, but before new cells are activated,
 *  we will punish incorrectly predict cells that won't become active
 *  (not in and active column).
 * @TemporalMemory
 */
CREATE TRIGGER trigger_input_a_synapse_nonpredict_punish_change
  AFTER UPDATE OF columns_active
  ON htm.input
  FOR EACH ROW
    WHEN (htm.config('synapse_distal_learn')::BOOL IS TRUE)
    EXECUTE FUNCTION htm.synapse_distal_nonpredict_punish_update();

/**
 * Auto-update `cell.active` based on recently activated SP columns. Use
 * views which are also up-to-date.
 * @TemporalMemory
 */
CREATE TRIGGER trigger_input_cell_active_change
  AFTER UPDATE OF columns_active
  ON htm.input
  FOR EACH ROW
    EXECUTE FUNCTION htm.cell_active_update();

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
  BEFORE UPDATE OF columns_active, columns_predict
  ON htm.input
  FOR EACH ROW
    EXECUTE FUNCTION htm.schema_modified_update();

