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
  -- All done, update compute iteration count and return
  PERFORM htm.spatial_pooler_set(
    'compute_iterations', 
    (compute_iterations + 1)::VARCHAR
  );
  RETURN FOUND;
END; 
$$ LANGUAGE plpgsql;

