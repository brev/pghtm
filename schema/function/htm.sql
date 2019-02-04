/**
 * HTM Schema-wide Functions
 */


/**
 * Unroll index counts from inside nested loops to a single index count.
 */
CREATE FUNCTION htm.count_unloop(outerCount INT, innerCount INT, innerMax INT)
RETURNS INT
AS $$
BEGIN
  RETURN ((outerCount - 1) * innerMax) + innerCount;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

/**
 * Raise a notice message (debug output) if debugging enabled
 */
CREATE FUNCTION htm.debug(text)
RETURNS VOID
AS $$
BEGIN
  IF htm.config('debug') THEN
    RAISE NOTICE '%', $1;
  END IF;
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Generate a random integer between low and high constraints.
 */
CREATE FUNCTION htm.random_range_int(low INT, high INT)
RETURNS INT
AS $$
BEGIN
   RETURN FLOOR((RANDOM() * (high - low + 1)) + low);
END;
$$ LANGUAGE plpgsql;

/**
 * Generate a random float between low and high constraints.
 */
CREATE FUNCTION htm.random_range_numeric(low NUMERIC, high NUMERIC)
RETURNS NUMERIC
AS $$
BEGIN
   RETURN (RANDOM() * (high - low)) + low;
END;
$$ LANGUAGE plpgsql;

/**
 * Calculate a running moving average (for column duty cycle calculations)
 * @SpatialPooler
 */
CREATE FUNCTION htm.running_moving_average(
  previous NUMERIC,
  next NUMERIC,
  period INT
)
RETURNS NUMERIC
AS $$
DECLARE
  safePeriod CONSTANT INT := GREATEST(1, period);
BEGIN
   RETURN (((safePeriod - 1) * previous) + next) / safePeriod;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

/**
 * Auto-update a "modified" column/field (like htm.input table) to now().
 */
CREATE FUNCTION htm.schema_modified_update()
RETURNS TRIGGER
AS $$
BEGIN
  NEW.modified = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/**
 * Wrap array index around the array, either direction.
 */
CREATE FUNCTION htm.wrap_array_index(target INT, max INT)
RETURNS INT
AS $$
DECLARE
  result INT;
BEGIN
  CASE
    WHEN target < 0
      THEN result := max + target;
    WHEN target >= max
      THEN result := target - max;
    ELSE
      result := target;
  END CASE;

  RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

