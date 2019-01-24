/**
 * Synapse (Distal: Connected) View
 * @TemporalMemory
 */
CREATE VIEW htm.synapse_distal_connected AS (
  SELECT synapse.id
  FROM htm.synapse
  JOIN htm.dendrite
    ON dendrite.id = synapse.dendrite_id
    AND dendrite.class = 'distal'
  WHERE htm.synapse_distal_get_connection(synapse.permanence)
);

