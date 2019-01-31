/**
 * Column (Overlap/Boosting) View
 * @SpatialPooler
 */
CREATE VIEW htm.column_overlap_boost AS (
  SELECT
    htm.column.id,
    segment_proximal_overlap_active.overlap,
    (
      segment_proximal_overlap_active.overlap *
      htm.column.boost_factor
    ) AS overlap_boosted
  FROM htm.column
  JOIN htm.link_proximal_segment_column
    ON link_proximal_segment_column.column_id = htm.column.id
  JOIN htm.segment
    ON segment.id = link_proximal_segment_column.segment_id
    AND segment.class = 'proximal'
  JOIN htm.segment_proximal_overlap_active
    ON segment_proximal_overlap_active.id = segment.id
);

