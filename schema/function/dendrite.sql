/**
 * Dendrite Functions
 */


/**
 * Check if a dendrite is active (# active syanpses above threshold).
 *  Currently for both distal and proximal.
 */
CREATE FUNCTION htm.dendrite_is_active(synapses_active INT)
RETURNS BOOL
AS $$
DECLARE
  threshold CONSTANT INT := htm.config('dendrite_synapse_threshold');
BEGIN
  RETURN synapses_active > threshold;
END;
$$ LANGUAGE plpgsql STABLE;

