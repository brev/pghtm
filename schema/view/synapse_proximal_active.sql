/**
 * Synapse (Proximal: Active) Views
 * @SpatialPooler
 */
CREATE VIEW htm.synapse_proximal_active AS (
  SELECT synapse.id
  FROM htm.synapse
  JOIN htm.synapse_proximal_connect
    ON synapse_proximal_connect.id = synapse.id
  JOIN htm.link_proximal_input_synapse
    ON link_proximal_input_synapse.synapse_id = synapse.id
    AND ARRAY[link_proximal_input_synapse.input_index] <@ (
      SELECT input.indexes  -- most recent input
      FROM htm.input
      ORDER BY input.id DESC
      LIMIT 1
    )
);

