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
 * Grow new segments/synapses on appropriate learning anchor cells.
 * @TemporalMemory
 */
CREATE TRIGGER trigger_cell_anchor_segment_synapse_grow_change
  AFTER UPDATE OF active
  ON htm.cell
  EXECUTE FUNCTION htm.cell_anchor_segment_synapse_grow_update();

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
 * After cell.active has been updated (and thus the distal views, too),
 *  we can perform Hebbian-style learning on the distal synapse permanances
 *  based on the newly-predictive cells. Check global feature flag first.
 * @TemporalMemory
 */
CREATE TRIGGER trigger_cell_synapse_distal_permanence_learn_change
  AFTER UPDATE OF active
  ON htm.cell
  WHEN (htm.config('synapse_distal_learn')::BOOL IS TRUE)
  EXECUTE FUNCTION htm.synapse_distal_learn_update();

