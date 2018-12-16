/** 
 * Link: Axon from Neuron to Synapse
 */

DO
$$
DECLARE
  CountDendrite INT := htm.configInt('DataSimpleCountDendrite');
  CountNeuron INT := htm.configInt('DataSimpleCountNeuron');
  CountSynapse INT := htm.configInt('DataSimpleCountSynapse');
  TotalSynapse INT := CountDendrite * CountNeuron * CountSynapse;
  neuronId INT;
BEGIN
  FOR synapseId IN 1..TotalSynapse LOOP
    neuronId := htm.randomRange(1, CountNeuron); 
    INSERT
      INTO htm.link_neuron_synapse(id, neuron_id, synapse_id)
      VALUES (synapseId, neuronId, synapseId);
  END LOOP;
END
$$;

