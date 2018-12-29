/**
 * Dendrite Functions
 */


/**
 *
 */
CREATE FUNCTION htm.dendrite_activated(synapse_count BIGINT)
RETURNS BOOL
AS $$
DECLARE
  ThresholdDendrite CONSTANT INT := htm.config('ThresholdDendrite');
BEGIN
  RETURN synapse_count > ThresholdDendrite;
END;
$$ LANGUAGE plpgsql;

