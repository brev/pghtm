/** 
 * Link: Axon from Neuron to Synapse Data
 */

DO
$$
DECLARE
  CountDendrite INT := htm.config_int('DataSimpleCountDendrite');
  CountNeuron INT := htm.config_int('DataSimpleCountNeuron');
  CountSynapse INT := htm.config_int('DataSimpleCountSynapse');
  TotalSynapse INT := CountDendrite * CountNeuron * CountSynapse;
  neuronId INT;
BEGIN
  FOR synapseId IN 1..TotalSynapse LOOP
    neuronId := htm.random_range(1, CountNeuron); 
    INSERT
      INTO htm.link_neuron_synapse(id, neuron_id, synapse_id)
      VALUES (synapseId, neuronId, synapseId);
  END LOOP;
END
$$;

