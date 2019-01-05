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
  DendriteThreshold CONSTANT INT := htm.config('DendriteThreshold');
BEGIN
  RETURN synapse_count > DendriteThreshold;
END;
$$ LANGUAGE plpgsql;

