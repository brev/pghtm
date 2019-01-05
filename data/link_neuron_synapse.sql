/** 
 * Link: Axon from Neuron to Synapse Data
 */

DO
$$
DECLARE
  CountDendrite INT := htm.config('CountDendrite');
  CountNeuron INT := htm.config('CountNeuron');
  CountSynapse INT := htm.config('CountSynapse');
  TotalSynapse INT := CountDendrite * CountNeuron * CountSynapse;
  neuronId INT;
BEGIN
  FOR synapseId IN 1..TotalSynapse LOOP
    neuronId := htm.random_range_int(1, CountNeuron); 
    INSERT
      INTO htm.link_neuron_synapse(id, neuron_id, synapse_id)
      VALUES (synapseId, neuronId, synapseId);
  END LOOP;
END
$$;

