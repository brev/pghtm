/**
 * Neuron Triggers
 */


/**
 * After neuron.active has been updated (and thus the distal views, too),
 *  we can perform Hebbian-style learning on the distal synapse permanances
 *  based on the newly-predictive neurons. Check global feature flag first.
 * @TemporalMemory
 */
CREATE TRIGGER trigger_neuron_synapse_distal_permanence_learn_change
  AFTER UPDATE OF active
  ON htm.neuron
  WHEN (htm.config('synapse_distal_learn')::BOOL IS TRUE)
  EXECUTE FUNCTION htm.synapse_distal_learn_update();

/**
 * After neuron.active has been updated (and thus the distal views, too),
 *  we can store fresh predicted neuron-columns back alongside original
 *  parent input data and SP results as TM prediction output.
 * @TemporalMemory
 */
CREATE TRIGGER trigger_neuron_input_columns_predict_change
  AFTER UPDATE OF active
  ON htm.neuron
  EXECUTE FUNCTION htm.input_columns_predict_update();

