/**
 * Synapse (Distal: Connected) View
 * @TemporalMemory
 */
CREATE VIEW htm.synapse_distal_connect AS (
  SELECT synapse.id
  FROM htm.synapse
  JOIN htm.segment
    ON segment.id = synapse.segment_id
    AND segment.class = 'distal'
  WHERE htm.synapse_distal_get_connection(synapse.permanence)
);

