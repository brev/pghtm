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
  learning CONSTANT BOOL := htm.var('spLearn');
  strength CONSTANT NUMERIC := htm.var('boostStrength');
BEGIN
  IF learning THEN
    RETURN EXP((0 - strength) * (duty_cycle - target_density));
  ELSE
    RETURN 1;  -- learning off
  END IF;
END; 
$$ LANGUAGE plpgsql;

/**
 * HTM - Get constant.
 *  You'll have to ::CAST on the other side.
 */
CREATE FUNCTION htm.const(key VARCHAR)
RETURNS VARCHAR
AS $$ 
DECLARE
  result VARCHAR;
BEGIN
  EXECUTE 
    FORMAT('SELECT %I FROM htm.constant LIMIT 1', LOWER(key))
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
  warm CONSTANT INTEGER := htm.var('dutyCyclePeriod');
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
  logging CONSTANT BOOLEAN := htm.var('logging');
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
  NEW.modified = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/**
 * HTM - Get variable.
 *  You'll have to ::CAST on the other side.
 */
CREATE FUNCTION htm.var(key VARCHAR)
RETURNS VARCHAR
AS $$ 
DECLARE
  result VARCHAR;
BEGIN
  EXECUTE 
    FORMAT('SELECT %I FROM htm.variable LIMIT 1', LOWER(key))
    INTO result;

  RETURN result;
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

