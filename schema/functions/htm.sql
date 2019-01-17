/**
 * HTM Global Schema Functions
 */


/**
 * HTM - SP Calculate new boosting factor (per Column).
 */
CREATE FUNCTION htm.boost_factor_compute(
  duty_cycle NUMERIC,
  target_density NUMERIC
)
RETURNS NUMERIC
AS $$
DECLARE
  learning CONSTANT BOOL := htm.config('sp_learn');
  strength CONSTANT NUMERIC := htm.config('boost_strength');
BEGIN
  IF learning THEN
    RETURN EXP((0 - strength) * (duty_cycle - target_density));
  ELSE
    RETURN 1;  -- learning off
  END IF;
END;
$$ LANGUAGE plpgsql;

/**
 * HTM - Get config setting.
 *  You'll probably need to ::CAST the result on the other side.
 */
CREATE FUNCTION htm.config(key VARCHAR)
RETURNS VARCHAR
AS $$
DECLARE
  result VARCHAR;
BEGIN
  EXECUTE
    FORMAT('SELECT %I FROM htm.config LIMIT 1', key)
    INTO result;

  RETURN result;
END;
$$ LANGUAGE plpgsql;

/**
 * HTM - Unroll index counts from inside nested loops to a single index count.
 */
CREATE FUNCTION htm.count_unloop(outerCount INT, innerCount INT, innerMax INT)
RETURNS INT
AS $$
BEGIN
  RETURN ((outerCount - 1) * innerMax) + innerCount;
END;
$$ LANGUAGE plpgsql;

/**
 * HTM - Get ideal duty cycle period value from several options.
 * @SpatialPooler
 */
CREATE FUNCTION htm.duty_cycle_period()
RETURNS INTEGER
AS $$
DECLARE
  cool CONSTANT INTEGER := htm.input_rows_count();
  warm CONSTANT INTEGER := htm.config('duty_cycle_period');
BEGIN
  RETURN LEAST (cool, warm);
END;
$$ LANGUAGE plpgsql;

/**
 * Raise a notice message (log output)
 */
CREATE FUNCTION htm.log(text)
RETURNS BOOLEAN
AS $$
DECLARE
  logging CONSTANT BOOLEAN := htm.config('logging');
BEGIN
  IF logging THEN
    RAISE NOTICE '%', $1;
  END IF;
  RETURN logging;
END;
$$ LANGUAGE plpgsql;

/**
 * HTM - Generate a random integer between low and high constraints.
 */
CREATE FUNCTION htm.random_range_int(low INT, high INT)
RETURNS INT
AS $$
BEGIN
   RETURN FLOOR((RANDOM() * (high - low + 1)) + low);
END;
$$ LANGUAGE plpgsql;

/**
 * HTM - Generate a random float between low and high constraints.
 */
CREATE FUNCTION htm.random_range_numeric(low NUMERIC, high NUMERIC)
RETURNS NUMERIC
AS $$
BEGIN
   RETURN (RANDOM() * (high - low)) + low;
END;
$$ LANGUAGE plpgsql;

/**
 * HTM - Calculate a running moving average (for duty cycle calculations)
 * @SpatialPooler
 */
CREATE FUNCTION htm.running_moving_average(
  previous NUMERIC,
  next NUMERIC,
  period INTEGER
)
RETURNS NUMERIC
AS $$
DECLARE
  safePeriod CONSTANT INT := GREATEST(1, period);
BEGIN
   RETURN (((safePeriod - 1) * previous) + next) / safePeriod;
END;
$$ LANGUAGE plpgsql;

/**
 * HTM - Auto-update a "modified" column/field (like htm.input table) to now().
 */
CREATE FUNCTION htm.schema_modified_update()
RETURNS TRIGGER
AS $$
BEGIN
  PERFORM htm.log('updating input.modified timestamp');
  NEW.modified = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/**
 * HTM - Wrap array index around the array, either direction.
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
$$ LANGUAGE plpgsql;

