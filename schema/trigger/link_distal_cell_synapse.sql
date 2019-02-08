/**
 * Link (Distal: Cell > Synapse) Triggers
 */


/**
 * Enforce that segments should never have multiple distal synapses to
 *  same pre-synaptic cell, this link should be unique per segment.
 * @TemporalMemory
 */
CREATE TRIGGER trigger_link_distal_cell_synapse_segment_unique_change
  BEFORE INSERT
  ON htm.link_distal_cell_synapse
  FOR EACH ROW
    EXECUTE FUNCTION htm.synapse_distal_segment_unique_update();

