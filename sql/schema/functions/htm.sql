/**
 *
 */
CREATE FUNCTION htm.configInt(key VARCHAR)
RETURNS INT
AS $$ 
BEGIN
  CASE key
    -- # of active synapses on active dendrite
    WHEN 'ThresholdDendriteSynapse'
      THEN RETURN 4;
    
    -- # of columms per region
    WHEN 'DataSimpleCountColumn'
      THEN RETURN 3; 
    -- # of dendrites per neuron
    WHEN 'DataSimpleCountDendrite'
      THEN RETURN 4; 
    -- # of neurons per region (rows x cols)
    WHEN 'DataSimpleCountNeuron'
      THEN RETURN 9; 
    -- # of rows per region
    WHEN 'DataSimpleCountRow'
      THEN RETURN 3;
    -- # of synapses per dendrite
    WHEN 'DataSimpleCountSynapse'
      THEN RETURN 9; 
    -- Bit Width of Input SDR
    WHEN 'DataSimpleWidthInput'
      THEN RETURN 21; 
  END CASE;
END; 
$$ LANGUAGE plpgsql;

/**
 *
 */
CREATE FUNCTION htm.configNumeric(key VARCHAR)
RETURNS NUMERIC
AS $$ 
BEGIN
  CASE key
    -- permanence level required for synapse to be active
    WHEN 'ThresholdSynapsePermanence'
      THEN RETURN 0.50;
  END CASE;
END; 
$$ LANGUAGE plpgsql;

/**
 *
 */
CREATE FUNCTION htm.countUnloop(outerCount INT, innerCount INT, innerMax INT)
RETURNS INT
AS $$ 
BEGIN
  RETURN ((outerCount - 1) * innerMax) + innerCount;
END; 
$$ LANGUAGE plpgsql;

/**
 *
 */
CREATE FUNCTION htm.randomRange(low INT, high INT) 
RETURNS INT 
AS $$
BEGIN
   RETURN FLOOR(RANDOM() * (high - low + 1) + low);
END;
$$ LANGUAGE plpgsql;

/**
 *
 */
CREATE FUNCTION htm.wrapArrayIndex(target INT, max INT) 
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

