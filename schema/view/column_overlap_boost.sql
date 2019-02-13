/**
 * Column (Overlap/Boosting) View
 * @SpatialPooler
 */
CREATE VIEW htm.column_overlap_boost AS (
  SELECT
    c.id,
    COUNT(spa.id) AS overlap,
    (COUNT(spa.id) * c.boost_factor) AS overlap_boosted
  FROM htm.column AS c
  JOIN htm.synapse_proximal AS sp
    ON sp.column_id = c.id
  JOIN htm.synapse_proximal_active AS spa
    ON spa.id = sp.id
  GROUP BY c.id
  HAVING htm.column_is_active(
    COUNT(spa.id)::INT
  )
);

