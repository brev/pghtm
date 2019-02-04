/**
 * Segment Data
 */

DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
  columnId INT;
BEGIN
  -- Distal dendrite segments are inserted as part of TM algo/functions

  -- Proximal static dendrite segments for SP
  RAISE NOTICE 'Inserting % Segments (Proximal)...', column_count;
  FOR columnId IN 1..column_count LOOP
    INSERT
      INTO htm.segment (class)
      VALUES ('proximal');
  END LOOP;
END
$$;

