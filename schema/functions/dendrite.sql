/**
 * Dendrite Functions
 */


/**
 * Check if a dendrite is active (# active syanpses above threshold).
 */
CREATE FUNCTION htm.dendrite_is_active(active_synapses INT)
RETURNS BOOL
AS $$
DECLARE
  dendrite_synapse_threshold CONSTANT NUMERIC :=
    htm.config('dendrite_synapse_threshold');
BEGIN
  RETURN active_synapses > dendrite_synapse_threshold;
END;
$$ LANGUAGE plpgsql STABLE;

