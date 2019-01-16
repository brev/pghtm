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
  synapse_threshold CONSTANT NUMERIC := htm.var('synapse_threshold');
BEGIN
  RETURN permanence > synapse_threshold;
END; 
$$ LANGUAGE plpgsql;

/**
 * Nudge potential synapse permanence down according to learning rules.
 */
CREATE FUNCTION htm.synapse_permanence_decrement(permanence NUMERIC)
RETURNS NUMERIC
AS $$ 
DECLARE
  decrement CONSTANT NUMERIC := htm.var('synapse_decrement');
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
  increment CONSTANT NUMERIC := htm.var('synapse_increment');
BEGIN
  RETURN LEAST(permanence + increment, 1.0);
END; 
$$ LANGUAGE plpgsql;

/**
 * Perform the overlapDutyCycle/synaptic-related parts of boosting.
 *  Promote underwhelmed columns via synaptic permanence increase to
 *  stoke future wins.
 */
CREATE FUNCTION htm.synapse_permanence_boost_update()
RETURNS TRIGGER
AS $$ 
DECLARE
BEGIN
  PERFORM htm.log('synapse boosting'); 
  WITH synapse_next AS (
    SELECT
      synapse.id,
      htm.synapse_permanence_increment(synapse.permanence) AS permanence
    FROM htm.synapse
    JOIN htm.dendrite
      ON dendrite.id = synapse.dendrite_id
      AND dendrite.class = 'proximal'
    JOIN htm.link_dendrite_column
      ON link_dendrite_column.dendrite_id = dendrite.id
    JOIN htm.column
      ON htm.column.id = link_dendrite_column.column_id
    JOIN htm.region
      ON region.id = htm.column.region_id
      AND region.duty_cycle_overlap_mean > htm.column.duty_cycle_overlap
  )
  UPDATE htm.synapse
    SET permanence = synapse_next.permanence
    FROM synapse_next
    WHERE synapse_next.id = synapse.id;

  RETURN NULL;
END; 
$$ LANGUAGE plpgsql;

/**
 * Perform Hebbian-style learning on synapse permanences. This is based on
 *  recently-actived winners in column_active. This was triggered from an 
 *  update on the column table.
 */
CREATE FUNCTION htm.synapse_permanence_learn_update()
RETURNS TRIGGER
AS $$ 
DECLARE
BEGIN
  PERFORM htm.log('synapse learning'); 
  WITH synapse_next AS (
    SELECT
      synapse.id,
      (CASE
        WHEN synapse_proximal_active.id IS NOT NULL
          THEN htm.synapse_permanence_increment(synapse.permanence)
        ELSE
          htm.synapse_permanence_decrement(synapse.permanence)
      END) AS permanence
    FROM htm.synapse
    LEFT JOIN htm.synapse_proximal_active
      ON htm.synapse_proximal_active.id = synapse.id
    JOIN htm.dendrite
      ON dendrite.id = synapse.dendrite_id
      AND dendrite.class = 'proximal'
    JOIN htm.link_dendrite_column
      ON link_dendrite_column.dendrite_id = dendrite.id
    JOIN htm.column_active
      ON column_active.id = link_dendrite_column.column_id
  )
  UPDATE htm.synapse
    SET permanence = synapse_next.permanence
    FROM synapse_next
    WHERE synapse_next.id = synapse.id;

  RETURN NULL;
END; 
$$ LANGUAGE plpgsql;

