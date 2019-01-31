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
  RAISE NOTICE 'Inserting % Segments (Distal)...',
    (cell_count * segment_count);

  FOR cellId IN 1..cell_count LOOP
    FOR localId IN 1..segment_count LOOP
      segmentId := htm.count_unloop(cellId, localId, segment_count);
      INSERT
        INTO htm.segment (id, class)
        VALUES (segmentId, 'distal');
    END LOOP;
  END LOOP;

  RAISE NOTICE 'Inserting % Segments (Proximal)...', column_count;

  FOR columnId IN 1..column_count LOOP
    INSERT
      INTO htm.segment (id, class)
      VALUES (segmentId + columnId, 'proximal');
  END LOOP;
END
$$;

