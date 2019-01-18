/**
 * Dendrite Functions
 */


/**
 * Check if a dendrite is active (# active syanpses above threshold).
 */
CREATE FUNCTION htm.dendrite_is_active(active_synapses INTEGER)
RETURNS BOOL
AS $$
DECLARE
  dendrite_threshold CONSTANT NUMERIC := htm.config('dendrite_threshold');
BEGIN
  RETURN active_synapses > dendrite_threshold;
END;
$$ LANGUAGE plpgsql STABLE;

