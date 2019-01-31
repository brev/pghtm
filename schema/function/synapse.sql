/**
 * Synapse Functions
 */


/**
 * Check if a distal synapse is considered connected (above permanence
 *  threshold) or not (potential).
 * @TemporalMemory
 */
CREATE FUNCTION htm.synapse_distal_get_connection(permanence NUMERIC)
RETURNS BOOL
AS $$
DECLARE
  synapse_distal_threshold CONSTANT NUMERIC :=
    htm.config('synapse_distal_threshold');
BEGIN
  RETURN permanence > synapse_distal_threshold;
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Nudge distal potential synapse permanence down according to learning rules.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_distal_get_decrement(permanence NUMERIC)
RETURNS NUMERIC
AS $$
DECLARE
  decrement CONSTANT NUMERIC := htm.config('synapse_distal_decrement');
BEGIN
  RETURN GREATEST(permanence - decrement, 0.0);
END;
$$ LANGUAGE plpgsql STABLE;

/**
 * Nudge distal connected synapse permanence up according to learning rules.
 * @SpatialPooler
 */
CREATE FUNCTION htm.synapse_distal_get_increment(permanence NUMERIC)
RETURNS NUMERIC
AS $$
DECLARE
  increment CONSTANT NUMERIC := htm.config('synapse_distal_increment');
BEGIN
  RETURN LEAST(permanence + increment, 1.0);
END;
$$ LANGUAGE plpgsql STABLE;

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
  PERFORM htm.debug('SP performing proximal synaptic boosting');
  WITH synapse_next AS (
    SELECT
      s.id,
      htm.synapse_proximal_get_increment(s.permanence) AS permanence
    FROM htm.synapse AS s
    JOIN htm.segment AS d
      ON d.id = s.segment_id
      AND d.class = 'proximal'
    JOIN htm.link_proximal_segment_column AS lpdc
      ON lpdc.segment_id = d.id
    JOIN htm.column AS c
      ON c.id = lpdc.column_id
    JOIN htm.region AS r
      ON r.id = c.region_id
      AND r.duty_cycle_overlap_mean > c.duty_cycle_overlap
  )
  UPDATE htm.synapse AS s
    SET permanence = sn.permanence
    FROM synapse_next AS sn
    WHERE sn.id = s.id;

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
 * Perform Hebbian-style learning on distal synapse permanences. This is
 *  based on recently-predicted cells. This was triggered from an update
 *  on the `cell.active` field.
 * @TemporalMemory
 */
CREATE FUNCTION htm.synapse_distal_learn_update()
RETURNS TRIGGER
AS $$
DECLARE
BEGIN
  PERFORM htm.debug('TM performing distal synaptic learning');
  WITH synapse_next AS (
   SELECT
      s.id,
      (CASE
        WHEN sda.id IS NOT NULL
          THEN htm.synapse_distal_get_increment(s.permanence)
        ELSE
          htm.synapse_distal_get_decrement(s.permanence)
      END) AS permanence
    FROM htm.synapse AS s
    LEFT JOIN htm.synapse_distal_active AS sda
      ON sda.id = s.id
    JOIN htm.segment_distal_active AS dda
      ON dda.id = s.segment_id
    JOIN htm.link_distal_segment_cell AS lddn
      ON lddn.segment_id = s.segment_id
    JOIN htm.cell_distal_predict AS ndp
      ON ndp.id = lddn.cell_id
  )
  UPDATE htm.synapse AS s
    SET permanence = sn.permanence
    FROM synapse_next AS sn
    WHERE sn.id = s.id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

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
      s.id,
      (CASE
        WHEN spa.id IS NOT NULL
          THEN htm.synapse_proximal_get_increment(s.permanence)
        ELSE
          htm.synapse_proximal_get_decrement(s.permanence)
      END) AS permanence
    FROM htm.synapse AS s
    LEFT JOIN htm.synapse_proximal_active AS spa
      ON spa.id = s.id
    JOIN htm.segment AS d
      ON d.id = s.segment_id
      AND d.class = 'proximal'
    JOIN htm.link_proximal_segment_column AS lpdc
      ON lpdc.segment_id = d.id
    JOIN htm.column AS c
      ON c.id = lpdc.column_id
      AND c.active
  )
  UPDATE htm.synapse AS s
    SET permanence = sn.permanence
    FROM synapse_next AS sn
    WHERE sn.id = s.id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

