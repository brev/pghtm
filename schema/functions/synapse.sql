/**
 * Synapse Functions
 */


/**
 * Check if a synapse is considered connected (above permanence threshold) 
 *  or not (potential).
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
 * Auto-update htm.synapse.active field (from fresh htm.input row).
 *  Connected Synapses with new On Input bits are set synapse.active = TRUE.
 *  All other synapses will be synapse.active = false.
 */
CREATE FUNCTION htm.synapse_active_update()
RETURNS TRIGGER
AS $$
BEGIN
  WITH synapse_next AS (
    SELECT
      synapse.id AS synapse_id,
      (
        ARRAY[link_input_synapse.input_index] <@ NEW.indexes
        AND synapse.connected
      ) AS new_active
    FROM htm.synapse
    JOIN htm.link_input_synapse
      ON link_input_synapse.synapse_id = synapse.id
  )
  UPDATE htm.synapse
    SET active = synapse_next.new_active
    FROM synapse_next
    WHERE synapse.id = synapse_next.synapse_id; 

  RETURN NULL;
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

/**
 * Auto-update htm.synapse.connected column/field (from threshold calcs).
 */
CREATE FUNCTION htm.synapse_connected_update()
RETURNS TRIGGER
AS $$
BEGIN
  NEW.connected = htm.synapse_connected(NEW.permanence);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

