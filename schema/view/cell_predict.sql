/**
 * Cell (Predict) View
 * @TemporalMemory
 */
CREATE VIEW htm.cell_predict AS (
  SELECT
    c.id,
    c.column_id
  FROM htm.cell AS c
  JOIN htm.segment AS s
    ON s.cell_id = c.id
  JOIN htm.segment_distal_active AS sda
    ON sda.id = s.id
  GROUP BY c.id
  HAVING htm.cell_is_predict(
    COUNT(sda.id)::INT
  )
);

