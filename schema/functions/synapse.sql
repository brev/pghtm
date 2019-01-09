/**
 * Synapse Functions
 */


/**
 * Check if a synapse is considered connected (above permanence threshold) 
 *  or not (potential).
 */
CREATE FUNCTION htm.synapse_is_connected(permanence NUMERIC)
RETURNS BOOL
AS $$ 
DECLARE
  SynapseThreshold CONSTANT NUMERIC := htm.config('SynapseThreshold');
BEGIN
  RETURN permanence > SynapseThreshold;
END; 
$$ LANGUAGE plpgsql;

/**
 * Nudge potential synapse permanence down according to learning rules.
 */
CREATE FUNCTION htm.synapse_permanence_decrement(permanence NUMERIC)
RETURNS NUMERIC
AS $$ 
DECLARE
  decrement CONSTANT NUMERIC := htm.config('SynapseDecrement');
BEGIN
  RETURN GREATEST(permanence - decrement, 0.0);
END; 
$$ LANGUAGE plpgsql;

/**
 * Nudge connected synapse permanence up according to learning rules.
 */
CREATE FUNCTION htm.synapse_permanence_increment(permanence NUMERIC)
RETURNS NUMERIC
AS $$ 
DECLARE
  increment CONSTANT NUMERIC := htm.config('SynapseIncrement');
BEGIN
  RETURN LEAST(permanence + increment, 1.0);
END; 
$$ LANGUAGE plpgsql;

