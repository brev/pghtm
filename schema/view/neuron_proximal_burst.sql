/**
 * Neuron (Bursting) View
 * @TemporalMemory
 */
CREATE VIEW htm.neuron_proximal_burst AS (
  SELECT
    neuron.id,
    neuron.column_id
  FROM htm.neuron
  JOIN htm.column
    ON htm.column.id = neuron.column_id
    AND htm.column.active
);

