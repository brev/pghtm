/**
 * Synapse Functions
 */


/**
 * Check if a synapse is considered connected (above permanence threshold) 
 *  or not.
 */
CREATE FUNCTION htm.synapse_connected(permanence NUMERIC)
RETURNS BOOL
AS $$ 
DECLARE
  ThresholdSynapse CONSTANT NUMERIC := htm.config('ThresholdSynapse');
BEGIN
  RETURN permanence > ThresholdSynapse;
END; 
$$ LANGUAGE plpgsql;

/**
 * Nudge synapse permanence according to learning rules.
 *  Connected synapses are incremented, unconnected are decremented.
 */
CREATE FUNCTION htm.synapse_permanence_learn(permanence NUMERIC)
RETURNS NUMERIC
AS $$ 
DECLARE
  dec CONSTANT NUMERIC := htm.config('SynapseDecrement');
  inc CONSTANT NUMERIC := htm.config('SynapseIncrement');
  connected CONSTANT BOOL := htm.synapse_connected(permanence);
  result NUMERIC;
BEGIN
  IF connected THEN
    result := LEAST(permanence + inc, 1.0);  
  ELSE
    result := GREATEST(permanence - dec, 0.0);
  END IF;
  RETURN result;
END; 
$$ LANGUAGE plpgsql;

/**
 * HTM - Auto-update htm.synapse "state" column/field (from threshold calcs).
 */
CREATE FUNCTION htm.synapse_update_field_state()
RETURNS TRIGGER
AS $$
BEGIN
  IF NEW.state IS NULL THEN
    -- NEW.state = get_state_from_perm(NEW.permanence)
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

