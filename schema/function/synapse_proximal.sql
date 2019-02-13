/**
 * Synapse (Proximal) Functions
 */


/**
 * Perform the overlapDutyCycle/synaptic-related parts of boosting.
 *  Promote underwhelmed columns via synaptic permanence increase to
 *  stoke future wins. Use 1/10th of usual increment value, as per NuPIC SP.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_proximal_boost_update()
RETURNS TRIGGER
AS $$
DECLARE
BEGIN
  PERFORM htm.debug('SP performing proximal synaptic boosting');
  WITH synapse_next AS (
    SELECT
      sp.id,
      (htm.synapse_proximal_get_increment(sp.permanence) / 10.0) AS permanence
    FROM htm.synapse_proximal AS sp
    JOIN htm.column AS c
      ON c.id = sp.column_id
    JOIN htm.region AS r
      ON r.id = c.region_id
      AND r.duty_cycle_overlap_mean > c.duty_cycle_overlap
  )
  UPDATE htm.synapse_proximal AS sp
    SET permanence = sn.permanence
    FROM synapse_next AS sn
    WHERE sn.id = sp.id;

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
 *  based on recently-actived winner column, triggered from an update on
 *  the `column.active` field.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_proximal_learn_update()
RETURNS TRIGGER
AS $$
DECLARE
BEGIN
  PERFORM htm.debug('SP performing proximal synaptic learning');
  WITH synapse_next AS (
    SELECT
      sp.id,
      (CASE
        WHEN spa.id IS NOT NULL
          THEN htm.synapse_proximal_get_increment(sp.permanence)
        ELSE
          htm.synapse_proximal_get_decrement(sp.permanence)
      END) AS permanence
    FROM htm.synapse_proximal AS sp
    LEFT JOIN htm.synapse_proximal_active AS spa
      ON spa.id = sp.id
    JOIN htm.column AS c
      ON c.id = sp.column_id
      AND c.active
  )
  UPDATE htm.synapse_proximal AS sp
    SET permanence = sn.permanence
    FROM synapse_next AS sn
    WHERE sn.id = sp.id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

