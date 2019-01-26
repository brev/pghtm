/**
 * Neuron (Bursting) View
 * @TemporalMemory
 */
CREATE VIEW htm.neuron_proximal_burst AS (
  SELECT neuron.id
  FROM htm.neuron
  WHERE ARRAY[neuron.column_id] <@ (
    SELECT input.columns_active  -- most recent SP output
    FROM htm.input
    ORDER BY input.id DESC
    LIMIT 1
  )
);

