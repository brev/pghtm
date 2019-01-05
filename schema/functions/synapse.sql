/**
 * Synapse Functions
 */


/**
 * Check if a synapse is considered connected (above permanence threshold) 
 *  or not (potential/disconnected).
 */
CREATE FUNCTION htm.synapse_connected(permanence NUMERIC)
RETURNS BOOL
AS $$ 
DECLARE
  SynapseThreshold CONSTANT NUMERIC := htm.config('SynapseThreshold');
BEGIN
  RETURN permanence > SynapseThreshold;
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
 * Check if a synapse is considered at least potential (maybe connected) 
 *  (above permanence minimum) or disconnected.
 */
CREATE FUNCTION htm.synapse_potential(permanence NUMERIC)
RETURNS BOOL
AS $$ 
DECLARE
  SynapseMinimum CONSTANT NUMERIC := htm.config('SynapseMinimum');
BEGIN
  RETURN permanence > SynapseMinimum;
END; 
$$ LANGUAGE plpgsql;

/**
 * Detect htm.synapse.state type to use, based on permanance threshold calcs.
 */
CREATE FUNCTION htm.synapse_state_collapse(permanence NUMERIC)
RETURNS htm.SYNAPSE_STATE
AS $$
BEGIN
  IF htm.synapse_connected(permanence) THEN
    RETURN 'connected';
  ELSIF htm.synapse_potential(permanence) THEN
    RETURN 'potential';
  ELSE
    RETURN 'disconnected';
  END IF;
END;
$$ LANGUAGE plpgsql;

/**
 * Auto-update htm.synapse "state" column/field (from threshold calcs).
 */
CREATE FUNCTION htm.synapse_update_field_state()
RETURNS TRIGGER
AS $$
BEGIN
  NEW.state = htm.synapse_state_collapse(NEW.permanence);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

