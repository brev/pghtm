/**
 * Synapse Functions
 */


/**
 * Perform the overlapDutyCycle/synaptic-related parts of boosting.
 *  Promote underwhelmed columns via synaptic permanence increase to
 *  stoke future wins.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_proximal_boost_update()
RETURNS TRIGGER
AS $$
DECLARE
BEGIN
  PERFORM htm.debug('synapse boosting');
  WITH synapse_next AS (
    SELECT
      synapse.id,
      htm.synapse_proximal_get_increment(synapse.permanence) AS permanence
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
 * Check if a proximal synapse is considered connected (above permanence
 *  threshold) or not (potential).
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_proximal_get_connection(permanence NUMERIC)
RETURNS BOOL
AS $$
DECLARE
  synapse_proximal_threshold CONSTANT NUMERIC :=
    htm.config('synapse_proximal_threshold');
BEGIN
  RETURN permanence > synapse_proximal_threshold;
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Nudge proximal potential synapse permanence down according to learning rules.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_proximal_get_decrement(permanence NUMERIC)
RETURNS NUMERIC
AS $$
DECLARE
  decrement CONSTANT NUMERIC := htm.config('synapse_proximal_decrement');
BEGIN
  RETURN GREATEST(permanence - decrement, 0.0);
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Nudge proximal connected synapse permanence up according to learning rules.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_proximal_get_increment(permanence NUMERIC)
RETURNS NUMERIC
AS $$
DECLARE
  increment CONSTANT NUMERIC := htm.config('synapse_proximal_increment');
BEGIN
  RETURN LEAST(permanence + increment, 1.0);
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Perform Hebbian-style learning on proximal synapse permanences. This is
 *  based on recently-actived winners in column_active. This was triggered
 *  from an update on the column table.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_proximal_learn_update()
RETURNS TRIGGER
AS $$
DECLARE
BEGIN
  PERFORM htm.debug('synapse learning');
  WITH synapse_next AS (
    SELECT
      synapse.id,
      (CASE
        WHEN synapse_proximal_active.id IS NOT NULL
          THEN htm.synapse_proximal_get_increment(synapse.permanence)
        ELSE
          htm.synapse_proximal_get_decrement(synapse.permanence)
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

