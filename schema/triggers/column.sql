/**
 * Column Triggers
 */


/**
 * After column.duty_cycle_active is updated, we'll store the min/max in
 *  the parent region (for boosting).
 */
CREATE TRIGGER trigger_column_region_duty_cycles_change
  AFTER INSERT OR UPDATE
  ON htm.column
  EXECUTE FUNCTION htm.region_duty_cycles_update();

