/**
 * Column Data
 */
DO
$$
DECLARE
  ColumnCount INT := htm.config('ColumnCount');
BEGIN
  FOR columnId IN 1..ColumnCount LOOP
    INSERT INTO htm.column 
        (id, region_id, x_coord)
      VALUES
        (columnId, 1, columnId);
  END LOOP;
END
$$;

