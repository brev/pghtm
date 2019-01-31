/**
 * Cell (Predict) View
 * @TemporalMemory
 */
CREATE VIEW htm.cell_distal_predict AS (
  SELECT
    cell.id,
    cell.column_id
  FROM htm.cell
  JOIN htm.column
    ON htm.column.id = cell.column_id
    AND htm.column.active
  JOIN htm.link_distal_segment_cell
    ON link_distal_segment_cell.cell_id = cell.id
  JOIN htm.segment_distal_active
    ON segment_distal_active.id = link_distal_segment_cell.segment_id
  GROUP BY cell.id
  HAVING htm.cell_is_predict(
    COUNT(segment_distal_active.id)::INT
  )
);

