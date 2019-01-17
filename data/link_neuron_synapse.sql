/**
 * Link: Axon from Neuron to Synapse Data
 */

DO
$$
DECLARE
  dendrite_count INT := htm.config('dendrite_count');
  neuron_count INT := htm.config('neuron_count');
  synapse_count INT := htm.config('synapse_count');
  TotalSynapse INT := dendrite_count * neuron_count * synapse_count;
  neuronId INT;
BEGIN
  RAISE NOTICE 'Inserting % Links (Neuron => Synapse)...', TotalSynapse;

  FOR synapseId IN 1..TotalSynapse LOOP
    neuronId := htm.random_range_int(1, neuron_count);
    INSERT
      INTO htm.link_neuron_synapse(id, neuron_id, synapse_id)
      VALUES (synapseId, neuronId, synapseId);
  END LOOP;
END
$$;

