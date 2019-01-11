/**
 * Column Data
 */
DO
$$
DECLARE
  ColumnCount INT := htm.config('ColumnCount');
BEGIN
  FOR columnId IN 1..ColumnCount LOOP
    INSERT INTO htm.column (
      id, 
      boost_factor,
      duty_cycle_active, 
      duty_cycle_overlap,
      region_id, 
      x_coord
    )
    VALUES (
      columnId, 
      0.0,
      1.0, 
      1.0,
      1, 
      columnId
    );
  END LOOP;
END
$$;

