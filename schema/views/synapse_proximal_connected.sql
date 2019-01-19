/**
 * Synapse (Proximal: Connected) View
 * @SpatialPooler
 */
CREATE VIEW htm.synapse_proximal_connected AS (
  SELECT synapse.id
  FROM htm.synapse
  JOIN htm.dendrite
    ON dendrite.id = synapse.dendrite_id
    AND dendrite.class = 'proximal'
  WHERE htm.synapse_proximal_get_connection(synapse.permanence)
);

