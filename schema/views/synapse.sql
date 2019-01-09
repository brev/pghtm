/**
 * Synapse Views
 */


/**
 * Synapse (Connected) View
 */
CREATE VIEW htm.synapse_connected AS (
  SELECT
    synapse.id AS id,
    htm.synapse_is_connected(synapse.permanence) AS connected
  FROM htm.synapse
  WHERE htm.synapse_is_connected(synapse.permanence)
);

/**
 * Synapse (Active) Views
 */
CREATE VIEW htm.synapse_active AS (
  SELECT
    synapse.id AS id,
    TRUE AS active
  FROM htm.synapse
  JOIN htm.synapse_connected
    ON synapse_connected.id = synapse.id
  JOIN htm.link_input_synapse
    ON link_input_synapse.synapse_id = synapse.id
    AND ARRAY[link_input_synapse.input_index] <@ (
      SELECT input.indexes
      FROM htm.input
      ORDER BY input.id DESC
      LIMIT 1
    )
);

