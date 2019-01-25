/**
 * Synapse (Distal: Active) Views
 * @TemporalMemory
 */
CREATE VIEW htm.synapse_distal_active AS (
  SELECT synapse.id
  FROM htm.synapse
  JOIN htm.synapse_distal_connect
    ON synapse_distal_connect.id = synapse.id
  JOIN htm.dendrite
    ON dendrite.id = synapse.dendrite_id
    AND dendrite.class = 'distal'
  JOIN htm.link_distal_neuron_synapse
    ON link_distal_neuron_synapse.synapse_id = synapse.id
  JOIN htm.neuron
    ON neuron.id = link_distal_neuron_synapse.neuron_id
    AND neuron.active
);

