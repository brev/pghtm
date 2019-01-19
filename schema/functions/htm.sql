/**
 * HTM Schema-wide Functions
 */


/**
 * Get single specific config setting.
 *  You'll need to ::CAST the result on the other side.
 */
CREATE FUNCTION htm.config(key_in VARCHAR)
RETURNS VARCHAR
AS $$
DECLARE
  -- Region/Column height # neuron rows
  height CONSTANT INT := 1;
  -- Region/Column/Input width # neuron cols/bits
  width CONSTANT INT := 100;
  -- Synapse spread, to calc # of synapses per dendrite
  synapse_spread_pct CONSTANT NUMERIC := 0.5;

  /* config */
  result CONSTANT NUMERIC := (
    SELECT value FROM (VALUES
      -- column_active_limit: Number of top active columns to win
      --  during Inhibition - IDEAL 2%.
      --  nupic sp:numActiveColumnsPerInhArea "kth nearest score"
      --  @SpatialPooler
      ('column_active_limit', width * 0.04),

      -- column_boost_strength: SP Boosting strength
      --  @SpatialPooler
      ('column_boost_strength', 1.2),

      -- column_count: # of columms per region
      ('column_count', width),

      -- column_duty_cycle_period: Duty cycle period
      --  @SpatialPooler
      ('column_duty_cycle_period', 1000),

      -- column_inhibit: SP global inhibition flag
      --  @SpatialPooler
      ('column_inhibit', TRUE::INT),

      -- dendrite_count: # of dendrites per neuron
      ('dendrite_count', 4),

      -- dendrite_synapse_threshold: # active synapses required for an
      --  active dendrite. Can be used like a low-pass noise filter.
      --  nupic sp:stimulusThreshold=0
      --  nupic tm:?=?
      ('dendrite_synapse_threshold', 1),

      -- input_width: Input SDR Bit Width
      --  @SpatialPooler
      ('input_width', width),

      -- log: output warn notices and do helpful/slow logging?
      ('log', FALSE::INT),

      -- neuron_count: # of neurons per region (rows x cols)
      ('neuron_count', height * width),

      -- row_count: # of neuron rows high in each column/region
      --  1  = First-order memory, better for static spatial inference
      --  2+ = Variable-order memory, better for dynamic temporal inference
      ('row_count', height),

      -- synapse_count: # of synapses per dendrite
      ('synapse_count', width * synapse_spread_pct),

      -- synapse_distal_learn: TM learning on? flag
      --  @TemporalMemory
      ('synapse_distal_learn', TRUE::INT),

      -- synapse_distal_decrement: Synapse learning permanence decrement
      --  nupic tm:?
      --  @TemporalMemory
      ('synapse_distal_decrement', 0.01),

      -- synapse_distal_increment: Synapse learning permanence increment
      --  nupic tm:?
      --  @TemporalMemory
      ('synapse_distal_increment', 0.01),

      -- synapse_distal_spread_pct: % input bits each column may connect
      --  @TemporalMemory
      ('synapse_distal_spread_pct', synapse_spread_pct),

      -- synapse_distal_threshold: Synapse connect permanence threshold
      --  > is connected, <= is potential
      --  nupic tm:connectedPerm=0.5
      --  @TemporalMemory
      ('synapse_distal_threshold', 0.5),

      -- synapse_proximal_learn: SP learning on? flag
      --  @SpatialPooler
      ('synapse_proximal_learn', TRUE::INT),

      -- synapse_proximal_decrement: Synapse learning permanence decrement
      --  nupic sp:synPermActiveDec
      --  @SpatialPooler
      ('synapse_proximal_decrement', 0.01),

      -- synapse_proximal_increment: Synapse learning permanence increment
      --  nupic sp:synPermActiveInc
      --  @SpatialPooler
      ('synapse_proximal_increment', 0.01),

      -- synapse_proximal_spread_pct: % input bits each column may connect
      --  nupic sp:potentialPct "receptive field"
      --  @SpatialPooler
      ('synapse_proximal_spread_pct', synapse_spread_pct),

      -- synapse_proximal_threshold: Synapse connect permanence threshold
      --  > is connected, <= is potential
      --  nupic sp:synPermConnected=0.1
      --  @SpatialPooler
      ('synapse_proximal_threshold', 0.1)
    ) AS config_tmp (key, value)
    WHERE key = key_in
  );
BEGIN
  RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

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
 * Raise a notice message (log output) if logging enabled
 */
CREATE FUNCTION htm.log(text)
RETURNS BOOL
AS $$
DECLARE
  log CONSTANT BOOL := htm.config('log');
BEGIN
  IF log THEN
    RAISE NOTICE '%', $1;
  END IF;
  RETURN log;
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
  PERFORM htm.log('updating input.modified timestamp');
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

