/**
 * Cell Triggers
 */


/**
 * Whenever a `cell.active` state is updated, we automatically save
 *  the `OLD.active` value into the `NEW.active_last` field. This helps
 *  the Temporal Memory extend backward into time.
 * @TemporalMemory
 */
CREATE TRIGGER trigger_cell_active_last_change
  BEFORE UPDATE OF active
  ON htm.cell
  FOR EACH ROW
    EXECUTE FUNCTION htm.cell_active_last_update();

/**
 * Learn on appropriate learning anchor cells that already had helpful
 *  segments/synapses.
 * @TemporalMemory
 */
CREATE TRIGGER trigger_cell_anchor_synapse_learn_change
  AFTER UPDATE OF active
  ON htm.cell
  WHEN (htm.config('synapse_distal_learn')::BOOL IS TRUE)
  EXECUTE FUNCTION htm.synapse_distal_anchor_learn_update();

/**
 * Grow new segments/synapses on appropriate learning anchor cells.
 * @TemporalMemory
 */
CREATE TRIGGER trigger_cell_anchor_synapse_segment_grow_change
  AFTER UPDATE OF active
  ON htm.cell
  WHEN (htm.config('synapse_distal_learn')::BOOL IS TRUE)
  EXECUTE FUNCTION htm.cell_anchor_synapse_segment_grow_update();

/**
 * After cell.active has been updated (and thus the distal views, too),
 *  we can store fresh predicted cell-columns back alongside original
 *  parent input data and SP results as TM prediction output.
 * @TemporalMemory
 */
CREATE TRIGGER trigger_cell_input_columns_predict_change
  AFTER UPDATE OF active
  ON htm.cell
  EXECUTE FUNCTION htm.input_columns_predict_update();

/**
 * Auto-update htm.cell.modified column/field to NOW() on row update.
 */
CREATE TRIGGER trigger_cell_modified_change
  BEFORE UPDATE
  ON htm.cell
  FOR EACH ROW
    EXECUTE FUNCTION htm.schema_modified_update();

