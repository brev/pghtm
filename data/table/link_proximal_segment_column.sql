/**
 * Link (Proximal): Segment to Column Data
 */

DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
  columnId INT;
BEGIN
  RAISE NOTICE 'Inserting % Proximal Links (Segment => Column)...',
    column_count;

  FOR columnId IN 1..column_count LOOP
    INSERT
      INTO htm.link_proximal_segment_column (segment_id, column_id)
      VALUES (columnId, columnId);
  END LOOP;
END
$$;

