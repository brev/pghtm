/**
 * Input Functions
 */


/**
 * SP compute cycle has finished, we have active winning columns, let's
 *  store them back in the input table with the original input data row.
 *  SP compute cycle is finished.
 */
CREATE FUNCTION htm.input_columns_active_update()
RETURNS TRIGGER
AS $$
BEGIN
  WITH input_next AS (
    SELECT 
      input.id,
      (SELECT ARRAY(
        SELECT id from htm.column_active ORDER BY id
      )) AS columns_active
    FROM htm.input
    WHERE input.columns_active IS NULL
    ORDER BY input.id DESC
    LIMIT 1 
  )
  UPDATE htm.input
    SET columns_active = input_next.columns_active
    FROM input_next
    WHERE input_next.id = input.id;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

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

