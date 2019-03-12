/**
 * Cell Data
 */

DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
  row_count CONSTANT INT := htm.config('row_count');
  columnId INT;
  ycount INT;
BEGIN
  FOR columnId IN 1..column_count LOOP
    FOR yCount IN 1..row_count LOOP
      INSERT
        INTO htm.cell (column_id, y_coord)
        VALUES (columnId, yCount);
    END LOOP;
  END LOOP;
END
$$;

