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
$$ LANGUAGE plpgsql STABLE;

/**
 * HTM - Get single specific config setting.
 *  You'll probably need to ::CAST the result on the other side.
 */
CREATE FUNCTION htm.config(key_in VARCHAR)
RETURNS VARCHAR
AS $$
DECLARE
  /* const */
  -- Region/Column/Input height # rows
  height CONSTANT INT := 1;

  -- % SP winner columns not inhibited
  pctColWin CONSTANT NUMERIC := 0.04;

  -- SP col can connect to this % of input
  spread CONSTANT NUMERIC := 0.5;

  -- Region/Input width # cols
  width CONSTANT INT := 100;

  /* calc */
  -- Total count of neurons
  cells CONSTANT INT := height * width;

  -- # SP win cols not inhibited
  colWin CONSTANT INT := width * pctColWin;

  -- Synapses per Dendrite
  synapses CONSTANT INT := width * spread;

  /* config */
  result CONSTANT NUMERIC := (
    SELECT value FROM (VALUES
      -- boost_strength: SP Boosting strength
      ('boost_strength', 1.5),

      -- column_count: # of columms per region
      ('column_count', width),

      -- column_threshold: Number of top active columns to win
      --  during Inhibition - IDEAL 2%
      --  nupic sp:numActiveColumnsPerInhArea
      ('column_threshold', colWin),

      -- dendrite_count: # of dendrites per neuron
      ('dendrite_count', 4),

      -- dendrite_threshold: # active synapses needed for an active dendrite.
      --  Can be used like a low-pass noise filter.
      --  nupic sp:stimulusThreshold=0
      ('dendrite_threshold', 1),

      -- duty_cycle_period: Duty cycle period
      ('duty_cycle_period', 1000),

      -- inhibition: SP inhibition type:
      --  0=off
      --  1=global
      --  2=local (TODO not built yet)
      ('inhibition', 1),

      -- input_width: Input SDR Bit Width
      ('input_width', width),

      -- logging: output warn notices for debug logging?
      ('logging', FALSE::INT),

      -- neuron_count: # of neurons per region (rows x cols)
      ('neuron_count', cells),

      -- potential_pct: % input bits each column may connect
      ('potential_pct', spread),

      -- row_count: # of rows per region
      ('row_count', height),

      -- sp_learn: SP learning on? flag
      ('sp_learn', TRUE::INT),

      -- synapse_count: # of synapses per dendrite
      ('synapse_count', synapses),

      -- synapse_decrement: Synapse learning permanence decrement
      --  nupic sp:synPermActiveDec
      ('synapse_decrement', 0.01),

      -- synapse_increment: Synapse learning permanence increment
      --  nupic sp:synPermActiveInc
      ('synapse_increment', 0.01),

      -- synapse_threshold: Synapse connect permanence threshold
      --  > is connected, <= is potential
      --  nupic sp:synPermConnected=0.1
      --  nupic tp:connectedPerm=0.5
      ('synapse_threshold', 0.3)
    ) AS config_tmp (key, value)
    WHERE key = key_in
  );
BEGIN
  RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

/**
 * HTM - Unroll index counts from inside nested loops to a single index count.
 */
CREATE FUNCTION htm.count_unloop(outerCount INT, innerCount INT, innerMax INT)
RETURNS INT
AS $$
BEGIN
  RETURN ((outerCount - 1) * innerMax) + innerCount;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

/**
 * HTM - Get ideal duty cycle period value from several options.
 * @SpatialPooler
 */
CREATE FUNCTION htm.duty_cycle_period()
RETURNS INT
AS $$
DECLARE
  cool CONSTANT INT := htm.input_rows_count();
  warm CONSTANT INT := htm.config('duty_cycle_period');
BEGIN
  RETURN LEAST (cool, warm);
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Raise a notice message (log output)
 */
CREATE FUNCTION htm.log(text)
RETURNS BOOL
AS $$
DECLARE
  logging CONSTANT BOOL := htm.config('logging');
BEGIN
  IF logging THEN
    RAISE NOTICE '%', $1;
  END IF;
  RETURN logging;
END;
$$ LANGUAGE plpgsql STABLE;

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
$$ LANGUAGE plpgsql IMMUTABLE;

