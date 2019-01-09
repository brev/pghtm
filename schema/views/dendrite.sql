/**
 * Dendrite Views
 */


/**
 * Dendrite (Proximal: Active, Overlap) View
 */
CREATE VIEW htm.dendrite_proximal_active_overlap AS (
  SELECT
    dendrite.id AS id,
    COUNT(synapse_proximal_active.id) AS overlap
  FROM htm.dendrite
  JOIN htm.synapse
    ON synapse.dendrite_id = dendrite.id
  JOIN htm.synapse_proximal_active
    ON synapse_proximal_active.id = synapse.id
  GROUP BY dendrite.id
  HAVING htm.dendrite_is_active(
    COUNT(synapse_proximal_active.id)::INTEGER
  )
);

