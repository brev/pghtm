/**
 * Cell Data
 */

DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
  row_count CONSTANT INT := htm.config('row_count');
  cellId INT;
BEGIN
  RAISE NOTICE 'Inserting % Cells...', (column_count * row_count);

  FOR columnId IN 1..column_count LOOP
    FOR yCount IN 1..row_count LOOP
      cellId := htm.count_unloop(columnId, yCount, row_count);
      INSERT
        INTO htm.cell (id, column_id, y_coord)
        VALUES (cellId, columnId, yCount);
    END LOOP;
  END LOOP;
END
$$;

