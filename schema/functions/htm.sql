/**
 * HTM Global Schema Functions.
 */


/**
 * HTM - Get config value.
 * @returns VARCHAR, so cast accordingly on usage, like: htm.config('CountColumn')::INT
 */
CREATE FUNCTION htm.config(keyIn VARCHAR)
RETURNS VARCHAR 
AS $$ 
DECLARE
  height INT := 3;
  width INT := 3;   
  cells INT := height * width;
  result NUMERIC := (SELECT value FROM (VALUES 
      ('connectedPerm',               0.50),    -- Synapse permanence level threshold for connection
      ('CountColumn',                 width),   -- # of columms per region
      ('CountDendrite',               4),       -- # of dendrites per neuron
      ('CountNeuron',                 cells),   -- # of neurons per region (rows x cols)
      ('CountRow',                    height),  -- # of rows per region
      ('CountSynapse',                9),       -- # of synapses per dendrite
      ('DeltaDecSynapsePermanence',   0.01),    -- decrement for synapse permanence during learning 
      ('DeltaIncSynapsePermanence',   0.01),    -- increment for synapse permanence during learning 
      ('ThresholdDendriteSynapse',    4),       -- # of active synapses on active dendrite
      ('WidthInput',                  21),      -- Bit Width of Input SDR
      ('UnitTestDummyData',           777)      -- Dummy data for unit testing this function
    ) AS config_tmp (key, value)
    WHERE key = keyIn
  );
BEGIN
  IF result IS NULL THEN
    RAISE EXCEPTION 'No value for key %', keyIn;
  END IF;
  RETURN result;
END; 
$$ LANGUAGE plpgsql IMMUTABLE;

/**
 * HTM - Unroll index counts inside nested loops, into a single new sequence index/ID.
 */
CREATE FUNCTION htm.count_unloop(outerCount INT, innerCount INT, innerMax INT)
RETURNS INT
AS $$ 
BEGIN
  RETURN ((outerCount - 1) * innerMax) + innerCount;
END; 
$$ LANGUAGE plpgsql;

/**
 * HTM - Generate a random integer between low and high constraints.
 */
CREATE FUNCTION htm.random_range(low INT, high INT) 
RETURNS INT 
AS $$
BEGIN
   RETURN FLOOR(RANDOM() * (high - low + 1) + low);
END;
$$ LANGUAGE plpgsql;

/**
 * HTM - Wrap array index around the array, either direction.
 */
CREATE FUNCTION htm.wrap_array_index(target INT, max INT) 
RETURNS INT 
AS $$
BEGIN
  CASE
    WHEN target < 0
      THEN RETURN max + target;
    WHEN target >= max
      THEN RETURN target - max;
    ELSE
      RETURN target;
  END CASE;
END;
$$ LANGUAGE plpgsql;

