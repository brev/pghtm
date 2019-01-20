/**
 * Column Data
 */
DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
BEGIN
  -- disable triggers on table for initial data fill
  ALTER TABLE htm.column DISABLE TRIGGER USER;

  RAISE NOTICE 'Inserting % Columns...', column_count;

  FOR columnId IN 1..column_count LOOP
    INSERT INTO htm.column (
      id,
      region_id,
      x_coord
    )
    VALUES (
      columnId,
      1,
      columnId
    );
  END LOOP;

  -- re-enable triggers on table for normal functioning
  ALTER TABLE htm.column ENABLE TRIGGER USER;
END
$$;

