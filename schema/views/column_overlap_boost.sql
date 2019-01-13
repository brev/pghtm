/**
 * Column (Overlap/Boosting) View
 */
CREATE VIEW htm.column_overlap_boost AS (
  SELECT
    htm.column.id,
    dendrite_proximal_overlap_active.overlap,
    (
      dendrite_proximal_overlap_active.overlap *
      htm.column.boost_factor
    ) AS overlap_boosted
  FROM htm.column
  JOIN htm.link_dendrite_column
    ON link_dendrite_column.column_id = htm.column.id
  JOIN htm.dendrite
    ON dendrite.id = link_dendrite_column.dendrite_id
    AND dendrite.class = 'proximal'
  JOIN htm.dendrite_proximal_overlap_active
    ON dendrite_proximal_overlap_active.id = dendrite.id
);

