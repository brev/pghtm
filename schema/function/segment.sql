/**
 * Segment Functions
 */


/**
 * Check if a segment is active (# active syanpses above threshold).
 *  Currently for both distal and proximal.
 * @SpatialPooler
 * @TemporalMemory
 */
CREATE FUNCTION htm.segment_is_active(synapses_active INT)
RETURNS BOOL
AS $$
DECLARE
  threshold CONSTANT INT := htm.config('segment_synapse_threshold');
BEGIN
  RETURN synapses_active > threshold;
END;
$$ LANGUAGE plpgsql STABLE;

