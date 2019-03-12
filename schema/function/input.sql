/**
 * Input Functions
 */


/**
 * SP compute cycle has finished, we have active winning columns, let's
 *  store them back in the input table with the original input data row.
 *  SP compute cycle is finished.
 * @SpatialPooler
 */
CREATE FUNCTION htm.input_columns_active_update()
RETURNS TRIGGER
AS $$
BEGIN
  PERFORM htm.debug('SP saving winner columns back alongside input row');
  WITH input_next AS (
    SELECT
      i.id,
      (SELECT ARRAY(
        SELECT c.id
        FROM htm.column AS c
        WHERE c.active
        ORDER BY c.id
      )) AS columns_active
    FROM htm.input AS i
    WHERE i.columns_active IS NULL
    ORDER BY i.id DESC
    LIMIT 1
  )
  UPDATE htm.input AS i
    SET columns_active = inx.columns_active
    FROM input_next AS inx
    WHERE inx.id = i.id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/**
 * TM compute cycle has finished, we have predicted cell-columns, let's
 *  store them back in the input table with the original parent input
 *  data row and SP winning active columns. TM compute cycle is finished.
 * @TemporalMemory
 */
CREATE FUNCTION htm.input_columns_predict_update()
RETURNS TRIGGER
AS $$
BEGIN
  PERFORM htm.debug('TM saving predicted cell-columns back with input row');
  WITH input_next AS (
    SELECT
      i.id,
      (SELECT ARRAY(
        SELECT DISTINCT(cp.column_id)
        FROM htm.cell_predict AS cp
        ORDER BY cp.column_id
      )) AS columns_predict
    FROM htm.input AS i
    WHERE i.columns_predict IS NULL
    ORDER BY i.id DESC
    LIMIT 1
  )
  UPDATE htm.input AS i
    SET columns_predict = inx.columns_predict
    FROM input_next AS inx
    WHERE inx.id = i.id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/**
 * Encode an integer (w/specs) into a Sparse Distributed Representation,
 * suitable for input into the Spatial Pooler.
 */
CREATE OR REPLACE FUNCTION htm.input_encode_integer(
  width INT,
  sparsity NUMERIC,
  min INT,
  max INT,
  wrap BOOL,
  value INT
)
RETURNS INT[]
AS $$
DECLARE
  sparse_width CONSTANT INT := width * sparsity;
  value_count CONSTANT INT := (max - min) + 1;
  out_index INT;
  out_indexes INT[];
  this_index INT;
  value_width INT;
BEGIN
  IF wrap THEN
    value_width := (width + (sparse_width - 1)) / value_count;
  ELSE
    value_width := width / value_count;
  END IF;

  out_index := (value - min) * value_width;

  FOR spare_index IN 0..(sparse_width - 1) LOOP
    this_index := out_index + spare_index;

    IF (wrap AND (this_index >= width)) THEN
      this_index := htm.wrap_array_index(this_index, width);
    END IF;

    IF (this_index < width) THEN
      out_indexes := ARRAY_APPEND(out_indexes, this_index);
    END IF;
  END LOOP;

  RETURN out_indexes;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

/**
 * Get current system compute iteration count. # of Rows from htm.input.
 *  Used for duty cyle period and calcs.
 * @SpatialPooler
 */
CREATE FUNCTION htm.input_rows_count()
RETURNS BIGINT
AS $$
DECLARE
  iteration CONSTANT BIGINT := (SELECT COUNT(input.id) FROM htm.input);
BEGIN
  RETURN iteration;
END;
$$ LANGUAGE plpgsql STABLE;

