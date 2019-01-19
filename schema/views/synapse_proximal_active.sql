/**
 * Synapse (Proximal: Active) Views
 * @SpatialPooler
 */
CREATE VIEW htm.synapse_proximal_active AS (
  SELECT synapse.id
  FROM htm.synapse
  JOIN htm.synapse_proximal_connected
    ON synapse_proximal_connected.id = synapse.id
  JOIN htm.link_input_synapse
    ON link_input_synapse.synapse_id = synapse.id
    AND ARRAY[link_input_synapse.input_index] <@ (
      SELECT input.indexes  -- most recent input
      FROM htm.input
      ORDER BY input.id DESC
      LIMIT 1
    )
);

