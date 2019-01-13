/**
 * Synapse (Connected) View
 */
CREATE VIEW htm.synapse_connected AS (
  SELECT synapse.id
  FROM htm.synapse
  WHERE htm.synapse_is_connected(synapse.permanence)
);

