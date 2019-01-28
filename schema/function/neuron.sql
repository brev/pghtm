/**
 * Neuron Functions
 */


/**
 * Update neuron activity flags based on recently selected active winner
    columns from the SP.
 * @TemporalMemory
 */
CREATE FUNCTION htm.neuron_active_update()
RETURNS TRIGGER
AS $$
BEGIN
  PERFORM htm.debug('TM updating neuron activity state via bursting/predicted');
  WITH neuron_next AS (
    WITH column_predict AS (
      SELECT DISTINCT(column_id) AS id
      FROM htm.neuron_distal_predict
    )
    SELECT
      neuron.id,
      (CASE
        WHEN (COUNT(neuron_distal_predict.id) > 0) THEN
          TRUE  -- predicted => active
        WHEN (
          (column_predict.id IS NULL) AND
          (COUNT(neuron_proximal_burst.id) > 0)
        ) THEN
          TRUE  -- bursting => active
        ELSE
          FALSE  -- not predict, not burst, nor bursting with predicted column
      END) AS active
    FROM htm.neuron
    LEFT JOIN column_predict
      ON column_predict.id = neuron.column_id
    LEFT JOIN htm.neuron_distal_predict
      ON neuron_distal_predict.id = neuron.id
    LEFT JOIN htm.neuron_proximal_burst
      ON neuron_proximal_burst.id = neuron.id
    GROUP BY
      neuron.id,
      column_predict.id
  )
  UPDATE htm.neuron
    SET active = neuron_next.active
    FROM neuron_next
    WHERE neuron_next.id = neuron.id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/**
 * Check if a neuron is predictive (# active distal dendrites above threshold).
 *  Threshold of 1 is the same as NuPIC's logical OR.
 * @TemporalMemory
 */
CREATE FUNCTION htm.neuron_is_predict(dendrites_active INT)
RETURNS BOOL
AS $$
DECLARE
  threshold CONSTANT INT := htm.config('neuron_dendrite_threshold');
BEGIN
  RETURN dendrites_active > threshold;
END;
$$ LANGUAGE plpgsql STABLE;

