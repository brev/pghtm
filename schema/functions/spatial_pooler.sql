/**
 * Spatial Pooler Functions
 */


/**
 * Spatial Pooler - Get stat.
 */
CREATE FUNCTION htm.spatial_pooler_get(keyOut VARCHAR)
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
CREATE FUNCTION htm.spatial_pooler_set(keyIn VARCHAR, valueIn VARCHAR)
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
 * Spatial Pooler - Single step of computation.
 */
CREATE FUNCTION htm.spatial_pooler_compute()
RETURNS BOOLEAN
AS $$ 
DECLARE
  compute_iterations INT := htm.spatial_pooler_get('compute_iterations');
BEGIN

  -- Calculate Overlap.
  --  For each Column, get a count of connected Synapses that are attached to
  --  active Input bits.
  WITH newinput (indexes) AS (
    SELECT indexes
      FROM htm.input
      ORDER BY id DESC
      LIMIT 1
  )
  SELECT col.id, COUNT(synapse.id) AS overlap
    FROM htm.column AS col
    JOIN htm.link_dendrite_column
      ON link_dendrite_column.column_id = col.id
    JOIN htm.dendrite
      ON dendrite.id = link_dendrite_column.dendrite_id
    JOIN htm.synapse
      ON synapse.dendrite_id = dendrite.id
      AND htm.synapse_connection(synapse.permanence)
    JOIN htm.link_input_synapse
      ON link_input_synapse.synapse_id = synapse.id
      AND link_input_synapse.input_index IN (
        SELECT unnest(indexes) FROM newinput
      )
    GROUP BY col.id
    ORDER BY col.id;  
 
  -- All done, update compute iteration count and return
  PERFORM htm.spatial_pooler_set(
    'compute_iterations', 
    (compute_iterations + 1)::VARCHAR
  );
  RETURN FOUND;
END; 
$$ LANGUAGE plpgsql;

