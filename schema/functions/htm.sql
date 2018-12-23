/**
 *
 */
CREATE FUNCTION htm.config_int(key VARCHAR)
RETURNS INT
AS $$ 
DECLARE
  Columns INT := 3;
  Rows INT := 3;
BEGIN
  CASE key
    -- # of columms per region
    WHEN 'DataSimpleCountColumn'
      THEN RETURN Columns; 
    -- # of dendrites per neuron
    WHEN 'DataSimpleCountDendrite'
      THEN RETURN 4; 
    -- # of neurons per region (rows x cols)
    WHEN 'DataSimpleCountNeuron'
      THEN RETURN (Columns * Rows); 
    -- # of rows per region
    WHEN 'DataSimpleCountRow'
      THEN RETURN Rows;
    -- # of synapses per dendrite
    WHEN 'DataSimpleCountSynapse'
      THEN RETURN 9; 
    -- Bit Width of Input SDR
    WHEN 'DataSimpleWidthInput'
      THEN RETURN 21; 
    
    -- # of active synapses on active dendrite
    WHEN 'ThresholdDendriteSynapse'
      THEN RETURN 4;

    -- Dummy data for unit testing this function
    WHEN 'UnitTestDummyData'
      THEN RETURN 777;
  END CASE;
END; 
$$ LANGUAGE plpgsql;

/**
 *
 */
CREATE FUNCTION htm.config_numeric(key VARCHAR)
RETURNS NUMERIC
AS $$ 
BEGIN
  CASE key
    -- decrement for synapse permanence during learning 
    WHEN 'DeltaDecSynapsePermanence'
      THEN RETURN 0.01;
    -- increment for synapse permanence during learning 
    WHEN 'DeltaIncSynapsePermanence'
      THEN RETURN 0.01;
    -- permanence level required for synapse to be connected (connectedPerm)
    WHEN 'ThresholdSynapsePermanence'
      THEN RETURN 0.50;
    
    -- Dummy data for unit testing this function
    WHEN 'UnitTestDummyData'
      THEN RETURN 6.66;
  END CASE;
END; 
$$ LANGUAGE plpgsql;

/**
 *
 */
CREATE FUNCTION htm.count_unloop(outerCount INT, innerCount INT, innerMax INT)
RETURNS INT
AS $$ 
BEGIN
  RETURN ((outerCount - 1) * innerMax) + innerCount;
END; 
$$ LANGUAGE plpgsql;

/**
 *
 */
CREATE FUNCTION htm.random_range(low INT, high INT) 
RETURNS INT 
AS $$
BEGIN
   RETURN FLOOR(RANDOM() * (high - low + 1) + low);
END;
$$ LANGUAGE plpgsql;

/**
 *
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

