/**
 * Link: Segment to Cell Data
 */

DO
$$
DECLARE
  segment_count CONSTANT INT := htm.config('segment_count');
  cell_count CONSTANT INT := htm.config('cell_count');
  linkId INT;
BEGIN
  RAISE NOTICE 'Inserting % Links (Segment => Cell)...',
    (cell_count * segment_count);

  FOR cellId IN 1..cell_count LOOP
    FOR segmentId IN 1..segment_count LOOP
      linkId := htm.count_unloop(cellId, segmentId, segment_count);
      INSERT
        INTO htm.link_distal_segment_cell (id, segment_id, cell_id)
        VALUES (linkId, linkId, cellId);
    END LOOP;
  END LOOP;
END
$$;

