/**
 * Link: Segment to Column Data
 */

DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
  segment_count CONSTANT INT := htm.config('segment_count');
  cell_count CONSTANT INT := htm.config('cell_count');
  lastSegmentId CONSTANT INT := cell_count * segment_count;
BEGIN
  RAISE NOTICE 'Inserting % Links (Segment => Column)...', column_count;

  FOR columnId IN 1..column_count LOOP
    INSERT
      INTO htm.link_proximal_segment_column (id, segment_id, column_id)
      VALUES (columnId, lastSegmentId + columnId, columnId);
  END LOOP;
END
$$;

