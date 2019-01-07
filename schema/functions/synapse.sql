/**
 * Synapse Functions
 */


/**
 * Check if a synapse is considered connected (above permanence threshold) 
 *  or not (potential/unconnected).
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
 * Auto-update htm.synapse.input field (from fresh htm.input row).
 *  Connected Synapses linked to new On Input bits are set synapse.input = true.
 *  All other synapses will be syanpse.input = false.
 */
CREATE FUNCTION htm.synapse_input_update()
RETURNS TRIGGER
AS $$
BEGIN
  WITH synapse_next IN (
    SELECT
      synapse.id AS synapse_id,
      (
        (synapse.state = 'connected') AND
        (link_input_synapse.input_index IN (SELECT unnest(NEW.indexes)))
      ) AS new_input
    FROM htm.synapse
    JOIN htm.link_input_synapse
      ON link_input_synapse.synapse_id = synapse.id;
  )
  UPDATE htm.synapse
    SET input = synapse_next.new_input
    FROM synapse_next
    WHERE synapse.id = synapse_next.synapse_id; 

  RETURN NULL;
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
 *  (above permanence minimum) or unconnected.
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
  CASE
    WHEN htm.synapse_connected(permanence) 
      THEN RETURN 'connected';
    WHEN htm.synapse_potential(permanence) 
      THEN RETURN 'potential';
    ELSE 
      RETURN 'unconnected';
  END CASE;
END;
$$ LANGUAGE plpgsql;

/**
 * Auto-update htm.synapse "state" column/field (from threshold calcs).
 */
CREATE FUNCTION htm.synapse_state_update()
RETURNS TRIGGER
AS $$
BEGIN
  NEW.state = htm.synapse_state_collapse(NEW.permanence);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

