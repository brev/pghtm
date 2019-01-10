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
        (id, region_id, x_coord, duty_cycle_active, duty_cycle_overlap)
      VALUES
        (columnId, 1, columnId, 1.0, 1.0);
  END LOOP;
END
$$;

