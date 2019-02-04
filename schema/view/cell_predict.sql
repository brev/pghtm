/**
 * Cell (Predict) View
 * @TemporalMemory
 */
CREATE VIEW htm.cell_predict AS (
  SELECT
    c.id,
    c.column_id
  FROM htm.cell AS c
  JOIN htm.link_distal_segment_cell AS ldsc
    ON ldsc.cell_id = c.id
  JOIN htm.segment_distal_active AS sda
    ON sda.id = ldsc.segment_id
  GROUP BY c.id
  HAVING htm.cell_is_predict(
    COUNT(sda.id)::INT
  )
);

