/**
 * Segment (Proximal: Active, Overlap) View
 * @SpatialPooler
 */
CREATE VIEW htm.segment_proximal_overlap_active AS (
  SELECT
    segment.id,
    COUNT(synapse_proximal_active.id) AS overlap
  FROM htm.segment
  JOIN htm.synapse
    ON synapse.segment_id = segment.id
  JOIN htm.synapse_proximal_active
    ON synapse_proximal_active.id = synapse.id
  WHERE segment.class = 'proximal'
  GROUP BY segment.id
  HAVING htm.segment_is_active(
    COUNT(synapse_proximal_active.id)::INT
  )
);

