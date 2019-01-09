/**
 * Input Functions
 */


/**
 * Get current system compute iteration count. # of Rows from htm.input.
 */
CREATE FUNCTION htm.input_rows_count()
RETURNS BIGINT 
AS $$
DECLARE
  iteration CONSTANT BIGINT := (SELECT COUNT(input.id) FROM htm.input);
BEGIN
  RETURN iteration;
END;
$$ LANGUAGE plpgsql;

