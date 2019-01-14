/**
 * Column Data
 */
DO
$$
DECLARE
  ColumnCount INT := htm.const('ColumnCount');
BEGIN
  -- disable triggers on table for initial data fill
  ALTER TABLE htm.column DISABLE TRIGGER USER;
  
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
  
  -- re-enable triggers on table for normal functioning
  ALTER TABLE htm.column ENABLE TRIGGER USER;
END
$$;

