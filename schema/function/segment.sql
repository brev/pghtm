/**
 * Segment Functions
 */


/**
 * Grow segments on learning anchor cells which did not already have them.
 * @TemporalMemory
 */
CREATE FUNCTION htm.segment_anchor_grow_updates(anchors INT[])
RETURNS INT[]
AS $$
DECLARE
  anchors_length CONSTANT INT := COALESCE(ARRAY_LENGTH(anchors, 1), 0);
  query_segment CONSTANT TEXT := $sql$
      WITH segments_new AS (
        INSERT INTO htm.segment (cell_id)
          VALUES %s
          RETURNING id
      ) SELECT ARRAY(
        SELECT id FROM segments_new
      )
  $sql$;
  new_rows TEXT[];
  new_sql TEXT;
  segments INT[];
BEGIN
  PERFORM htm.debug('..TM growing new segments');
  FOR index IN 1..anchors_length LOOP
    new_rows := ARRAY_APPEND(
      new_rows,
      FORMAT('(%s)', anchors[index])
    );
  END LOOP;
  new_sql := FORMAT(query_segment, ARRAY_TO_STRING(new_rows, ','));
  EXECUTE new_sql INTO segments;

  RETURN segments;
END;
$$ LANGUAGE plpgsql;

/**
 * Check if a segment is active (# active distal syanpses above threshold).
 * @TemporalMemory
 */
CREATE FUNCTION htm.segment_is_active(synapse_distal_active INT)
RETURNS BOOL
AS $$
DECLARE
  threshold CONSTANT INT := htm.config('segment_synapse_threshold');
BEGIN
  RETURN synapse_distal_active > threshold;
END;
$$ LANGUAGE plpgsql STABLE;

