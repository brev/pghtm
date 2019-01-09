/**
 * Input Functions
 */


/**
 * Get current system compute iteration count. # of Rows from htm.input.
 *  This is a speedy postgres-specific table row count method. It's also
 *  a non-exact estimate, and so may be off! TODO ?
 *  A much slower method:  SELECT COUNT(input.id) FROM htm.input
 */
CREATE FUNCTION htm.input_rows_count()
RETURNS BIGINT 
AS $$
DECLARE
  iteration CONSTANT BIGINT := (
    SELECT reltuples::BIGINT
    FROM pg_class
    WHERE oid = 'htm.input'::REGCLASS
  );
BEGIN
  RETURN iteration;
END;
$$ LANGUAGE plpgsql;

