/**
 * Synapse (Proximal: Connected) View
 * @SpatialPooler
 */
CREATE VIEW htm.synapse_proximal_connect AS (
  SELECT synapse.id
  FROM htm.synapse
  JOIN htm.segment
    ON segment.id = synapse.segment_id
    AND segment.class = 'proximal'
  WHERE htm.synapse_proximal_get_connection(synapse.permanence)
);

