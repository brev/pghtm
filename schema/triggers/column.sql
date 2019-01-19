/**
 * Column Triggers
 */


/**
 * Put winning active columns back into result field of input row.
 *  SP Compute cycle is complete.
 * @SpatialPooler
 */
CREATE TRIGGER trigger_column_input_columns_active_change
  AFTER INSERT OR UPDATE OF
    boost_factor,
    duty_cycle_active,
    duty_cycle_overlap
  ON htm.column
  EXECUTE FUNCTION htm.input_columns_active_update();

/**
 * After column.duty_cycle_active is updated, we'll store the min/max in
 *  the parent region (for boosting).
 * @SpatialPooler
 */
CREATE TRIGGER trigger_column_region_duty_cycles_change
  AFTER INSERT OR UPDATE OF
    boost_factor,
    duty_cycle_active,
    duty_cycle_overlap
  ON htm.column
  EXECUTE FUNCTION htm.region_duty_cycles_update();

/**
 * After column dutycyles are updated, we can complete this small last
 *  bit of boosting. Columns running under the mean average overlap duty
 *  cycle have all their synapse permanences incremented.
 * @SpatialPooler
 */
CREATE TRIGGER trigger_column_synapse_permanence_boost_change
  AFTER INSERT OR UPDATE OF
    boost_factor,
    duty_cycle_active,
    duty_cycle_overlap
  ON htm.column
  WHEN (htm.config('synapse_proximal_learn')::BOOL IS TRUE)
  EXECUTE FUNCTION htm.synapse_proximal_boost_update();

/**
 * After column dutycyles are updated (and thus views column_overlap_boost and
 *  column_active), we can perform Hebbian-style learning on the synapse
 *  permanances based on the winning columns. Check global feature flag first.
 * @SpatialPooler
 */
CREATE TRIGGER trigger_column_synapse_permanence_learn_change
  AFTER INSERT OR UPDATE OF
    boost_factor,
    duty_cycle_active,
    duty_cycle_overlap
  ON htm.column
  WHEN (htm.config('synapse_proximal_learn')::BOOL IS TRUE)
  EXECUTE FUNCTION htm.synapse_proximal_learn_update();

