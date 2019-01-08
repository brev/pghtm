/**
 * Spatial Pooler Functions
 */


/**
 * After inserting new input, update SP compute_iteration cycle counter.
 */
CREATE FUNCTION htm.sp_compute_iteration_update()
RETURNS TRIGGER
AS $$
DECLARE
  iteration INT := htm.sp_get('compute_iteration'); 
BEGIN
  PERFORM htm.sp_set(
    'compute_iteration', 
    (iteration + 1)::VARCHAR
  ); 
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/**
 * Spatial Pooler - Get stat.
 */
CREATE FUNCTION htm.sp_get(keyOut VARCHAR)
RETURNS VARCHAR
AS $$ 
BEGIN
  RETURN (
    SELECT value
    FROM htm.spatial_pooler 
    WHERE key = keyOut
  );
END; 
$$ LANGUAGE plpgsql;

/**
 * Spatial Pooler - Set stat.
 */
CREATE FUNCTION htm.sp_set(keyIn VARCHAR, valueIn VARCHAR)
RETURNS BOOLEAN
AS $$ 
BEGIN
  UPDATE htm.spatial_pooler 
    SET value = valueIn
    WHERE key = keyIn;

  RETURN FOUND;
END; 
$$ LANGUAGE plpgsql;

/**
 * Spatial Pooler - Figure active columns. 
 *  Calculate overlap scores for each column: get count of connected Synapses 
 *    that are attached to active Input bits.
 */
CREATE FUNCTION htm.sp_column_overlap(input_indexes INT[])
RETURNS BOOLEAN
AS $$ 
BEGIN
  WITH column_next AS (
    SELECT 
      htm.column.id AS column_id,
      SUM((
        link_input_synapse.input_index IN (
          SELECT unnest(input_indexes)
        ))::INTEGER
      ) AS new_overlap
    FROM htm.column
    JOIN htm.link_dendrite_column
      ON link_dendrite_column.column_id = htm.column.id
    JOIN htm.dendrite
      ON dendrite.id = link_dendrite_column.dendrite_id
      AND dendrite.class = 'proximal'
    JOIN htm.synapse
      ON synapse.dendrite_id = dendrite.id
      AND synapse.connection = 'connected'
    JOIN htm.link_input_synapse
      ON link_input_synapse.synapse_id = synapse.id
    GROUP BY htm.column.id
  )
  UPDATE htm.column
    SET overlap = column_next.new_overlap
    FROM column_next
    WHERE htm.column.id = column_next.column_id;

  RETURN FOUND;
END; 
$$ LANGUAGE plpgsql;

/**
 * Spatial Pooler - Figure active columns. 
 *  Apply global inhibition to sparsify actives. TODO:config('globalInhibit')
 */
CREATE FUNCTION htm.sp_column_active(input_indexes INT[])
RETURNS INT[]
AS $$ 
DECLARE
  colsave CONSTANT BIGINT := htm.config('ColumnThreshold');
  column_indexes INT[];
BEGIN
  column_indexes := (
    SELECT ARRAY(
      SELECT col.id
      FROM htm.column AS col
      JOIN htm.link_dendrite_column
        ON link_dendrite_column.column_id = col.id
      JOIN htm.dendrite
        ON dendrite.id = link_dendrite_column.dendrite_id
        AND dendrite.class = 'proximal'
      JOIN htm.synapse
        ON synapse.dendrite_id = dendrite.id
        AND synapse.connection = 'connected'
      JOIN htm.link_input_synapse
        ON link_input_synapse.synapse_id = synapse.id
        AND link_input_synapse.input_index 
          IN (SELECT unnest(input_indexes))
      GROUP BY col.id
      ORDER BY COUNT(synapse.id) DESC   -- overlap
      LIMIT colsave                     -- global inhibit
    )
  );

  RETURN column_indexes;
END; 
$$ LANGUAGE plpgsql;

/**
 * Spatial Pooler - Perform hebbian-style learning.
 */
CREATE FUNCTION htm.sp_synapse_learn(column_indexes INT[])
RETURNS BOOLEAN
AS $$ 
BEGIN
  WITH synapse_next AS (
    SELECT
      synapse.id AS synapse_id,
      htm.synapse_permanence_learn(synapse.permanence) AS new_permanence
    FROM htm.synapse
    JOIN htm.dendrite
      ON dendrite.id = synapse.dendrite_id
      AND dendrite.class = 'proximal'
    JOIN htm.link_dendrite_column
      ON link_dendrite_column.dendrite_id = dendrite.id
      AND link_dendrite_column.column_id IN (
        SELECT unnest(column_indexes)
      )
  )
  UPDATE htm.synapse
    SET permanence = synapse_next.new_permanence
    FROM synapse_next
    WHERE synapse_next.synapse_id = synapse.id;

  RETURN FOUND;
END; 
$$ LANGUAGE plpgsql;

/**
 * Spatial Pooler - Single step of computation.
 */
CREATE FUNCTION htm.sp_compute(input_indexes INT[])
RETURNS INT[]
AS $$ 
DECLARE
  learning CONSTANT BOOL := htm.config('spLearn');
  iteration INT := htm.sp_get('compute_iteration');
  active_columns INT[];
BEGIN
  -- Get winning columns (Overlap and Inhibition)
  active_columns := htm.sp_column_active(input_indexes);

  -- Learning
  IF learning THEN 
    PERFORM htm.sp_synapse_learn(active_columns);
  END IF;

  -- Update compute iteration count
  PERFORM htm.sp_set('compute_iteration', (iteration + 1)::VARCHAR);

  -- Return indexes of active columns
  RETURN active_columns;
END; 
$$ LANGUAGE plpgsql;

