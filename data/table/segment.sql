/**
 * Segment Data
 */

DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
  segment_count CONSTANT INT := htm.config('segment_count');
  cell_count CONSTANT INT := htm.config('cell_count');
  columnId INT;
  segmentId INT;
BEGIN
  -- Distal dendrite segments are inserted as part of TM algo/functions

  -- Proximal static dendrite segments for SP
  RAISE NOTICE 'Inserting % Segments (Proximal)...', column_count;
  FOR columnId IN 1..column_count LOOP
    INSERT
      INTO htm.segment (id, class)
      VALUES (columnId, 'proximal');
  END LOOP;
END
$$;

