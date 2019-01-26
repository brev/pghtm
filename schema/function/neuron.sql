/**
 * Neuron Functions
 */


/**
 * Check if a neuron is predictive (# active distal dendrites above threshold).
 *  Threshold of 1 is the same as NuPIC's logical OR.
 */
CREATE FUNCTION htm.neuron_is_predict(dendrites_active INT)
RETURNS BOOL
AS $$
DECLARE
  threshold CONSTANT INT := htm.config('neuron_dendrite_threshold');
BEGIN
  RETURN dendrites_active > threshold;
END;
$$ LANGUAGE plpgsql STABLE;

