/**
 * Neuron (Predict) View
 * @TemporalMemory
 */
CREATE VIEW htm.neuron_distal_predict AS (
  SELECT neuron.id
  FROM htm.neuron
  JOIN htm.link_distal_dendrite_neuron
    ON link_distal_dendrite_neuron.neuron_id = neuron.id
  JOIN htm.dendrite_distal_active
    ON dendrite_distal_active.id = link_distal_dendrite_neuron.dendrite_id
  JOIN htm.dendrite
    ON dendrite.id = link_distal_dendrite_neuron.dendrite_id
    AND dendrite.class = 'distal'
  GROUP BY neuron.id
  HAVING htm.neuron_is_predict(
    COUNT(dendrite_distal_active.id)::INT
  )
);

