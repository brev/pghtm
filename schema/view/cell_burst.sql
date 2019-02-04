/**
 * Cell (Bursting) View
 * @TemporalMemory
 */
CREATE VIEW htm.cell_burst AS (
  SELECT
    cell.id,
    cell.column_id
  FROM htm.cell
  JOIN htm.column
    ON htm.column.id = cell.column_id
    AND htm.column.active
);

