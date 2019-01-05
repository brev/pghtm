/**
 * HTM Global Schema Functions.
 */


/**
 * HTM - Get config value.
 * @returns VARCHAR, so cast on usage, like: 
 *  SQL:      SELECT htm.config('key')::INT;
 *  plpgsql:  val INT := htm.config('key');
 */
CREATE FUNCTION htm.config(keyIn VARCHAR)
RETURNS VARCHAR 
AS $$ 
DECLARE
  height CONSTANT INT := 1;         -- Region/Column/Input height # rows
  pctWin CONSTANT NUMERIC := 0.04;  -- % of SP winner columns not inhibited
  spread CONSTANT NUMERIC := 0.5;   -- SP column can connect to this % of input
  width CONSTANT INT := 100;        -- Region/Input width # cols

  cells CONSTANT INT := height * width;     -- Total count of neurons
  colWin CONSTANT INT := width * pctWin;    -- # of SP winner cols not inhibited
  synapses CONSTANT INT := width * spread;  -- Synapses per Dendrite
 
  result CONSTANT NUMERIC := (SELECT value FROM 
    (VALUES 
      -- HTM
      ('ColumnCount',       width),     -- # of columms per region
      ('DendriteCount',     4),         -- # of dendrites per neuron
      ('DendriteThreshold', 4),         -- # active synapse for dendrite connect
      ('InputWidth',        width),     -- Input SDR Bit Width 
      ('NeuronCount',       cells),     -- # of neurons per region (rows x cols)
      ('RowCount',          height),    -- # of rows per region
      ('SynapseCount',      synapses),  -- # of synapses per dendrite 
      ('SynapseDecrement',  0.01),      -- Synapse learning permanence decrement
                                          -- nupic sp:synPermActiveDec
      ('SynapseIncrement',  0.01),      -- Synapse learning permanence increment
                                          -- nupic sp:synPermActiveInc
      ('SynapseMinimum',    0.0),       -- Synapse potential perm min threshold,
                                          -- > is potential or connected
                                          -- <= is disconnected
      ('SynapseThreshold',  0.3),       -- Synapse connect permanence threshold
                                          -- > is connected
                                          -- <= is potential or disconnected
                                          -- nupic sp:synPermConnected=0.1 
                                          -- nupic tp:connectedPerm=0.5
      -- Spatial Pooler
      ('dutyCyclePeriod',   1000),    -- Duty cycle period
      ('globalInhibition',  1),       -- Global inhibition boolean toggle
                                        -- TODO topology not coded yet
      ('potentialPct',      spread),  -- % of in bits each column may connect
      ('spLearn',           1),       -- SP learning on?
      ('ThresholdColumn',   colWin),  -- Number of top active columns to win 
                                        -- during Inhibition - IDEAL 2%
                                        -- nupic sp:numActiveColumnsPerInhArea
      -- Other
      ('UnitTestData', 777)   -- Unit testing example data
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
 * HTM - Auto-update a "modified" column/field (like htm.input table) to now().
 */
CREATE FUNCTION htm.update_field_modified() 
RETURNS TRIGGER
AS $$
BEGIN
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

