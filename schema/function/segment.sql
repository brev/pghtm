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
  query_link CONSTANT TEXT :=
    'INSERT INTO htm.link_distal_segment_cell (segment_id, cell_id) VALUES %s';
  query_segment CONSTANT TEXT := $sql$
      WITH segments_new AS (
        INSERT INTO htm.segment (class)
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
    new_rows := ARRAY_APPEND(new_rows, FORMAT('(''%s'')', 'distal'));
  END LOOP;
  new_sql := FORMAT(query_segment, ARRAY_TO_STRING(new_rows, ','));
  EXECUTE new_sql INTO segments;

  PERFORM htm.debug('..TM growing new links from new segments => cells');
  new_rows := ARRAY[]::TEXT[];
  FOR index IN 1..anchors_length LOOP
    new_rows := ARRAY_APPEND(
      new_rows,
      FORMAT('(%s, %s)', segments[index], anchors[index])
    );
  END LOOP;
  new_sql := FORMAT(query_link, ARRAY_TO_STRING(new_rows, ','));
  EXECUTE new_sql;

  RETURN segments;
END;
$$ LANGUAGE plpgsql;

/**
 * Check if a segment is active (# active syanpses above threshold).
 *  Currently for both distal and proximal.
 * @SpatialPooler
 * @TemporalMemory
 */
CREATE FUNCTION htm.segment_is_active(synapses_active INT)
RETURNS BOOL
AS $$
DECLARE
  threshold CONSTANT INT := htm.config('segment_synapse_threshold');
BEGIN
  RETURN synapses_active > threshold;
END;
$$ LANGUAGE plpgsql STABLE;

