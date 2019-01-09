/**
 * Column Views
 */


/**
 * Column (Overlap) View
 */
CREATE VIEW htm.column_overlap AS (
  SELECT
    htm.column.id,
    dendrite_proximal_active_overlap.overlap
  FROM htm.column
  JOIN htm.link_dendrite_column
    ON link_dendrite_column.column_id = htm.column.id
  JOIN htm.dendrite
    ON dendrite.id = link_dendrite_column.dendrite_id
    AND dendrite.class = 'proximal'
  JOIN htm.dendrite_proximal_active_overlap
    ON dendrite_proximal_active_overlap.id = dendrite.id
);

