/**
 * Dendrite (Proximal: Active, Overlap) View
 * @SpatialPooler
 */
CREATE VIEW htm.dendrite_proximal_overlap_active AS (
  SELECT
    dendrite.id,
    COUNT(synapse_proximal_active.id) AS overlap
  FROM htm.dendrite
  JOIN htm.synapse
    ON synapse.dendrite_id = dendrite.id
  JOIN htm.synapse_proximal_active
    ON synapse_proximal_active.id = synapse.id
  WHERE dendrite.class = 'proximal'
  GROUP BY dendrite.id
  HAVING htm.dendrite_is_active(
    COUNT(synapse_proximal_active.id)::INT
  )
);

