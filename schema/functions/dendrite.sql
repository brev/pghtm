/**
 * Dendrite Functions
 */

CREATE FUNCTION htm.dendrite_activation(synapse_count BIGINT)
RETURNS BOOL
AS $$
DECLARE
  ThresholdDendrite INT := htm.config('ThresholdDendrite');
BEGIN
  RETURN synapse_count > ThresholdDendrite;
END;
$$ LANGUAGE plpgsql;

