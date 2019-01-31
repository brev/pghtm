/**
 * Link (Proximal): Segment to Column Data
 */

DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
BEGIN
  RAISE NOTICE 'Inserting % Proximal Links (Segment => Column)...',
    column_count;

  FOR columnId IN 1..column_count LOOP
    INSERT
      INTO htm.link_proximal_segment_column (id, segment_id, column_id)
      VALUES (columnId, columnId, columnId);
  END LOOP;
END
$$;

