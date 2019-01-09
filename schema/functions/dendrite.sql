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
  DendriteThreshold CONSTANT NUMERIC := htm.config('DendriteThreshold');
BEGIN
  RETURN active_synapses > DendriteThreshold;
END; 
$$ LANGUAGE plpgsql;

