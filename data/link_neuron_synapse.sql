/** 
 * Link: Axon from Neuron to Synapse Data
 */

DO
$$
DECLARE
  DendriteCount INT := htm.const('DendriteCount');
  NeuronCount INT := htm.const('NeuronCount');
  SynapseCount INT := htm.const('SynapseCount');
  TotalSynapse INT := DendriteCount * NeuronCount * SynapseCount;
  neuronId INT;
BEGIN
  RAISE NOTICE 'Inserting % Links (Neuron => Synapse)...', TotalSynapse;

  FOR synapseId IN 1..TotalSynapse LOOP
    neuronId := htm.random_range_int(1, NeuronCount); 
    INSERT
      INTO htm.link_neuron_synapse(id, neuron_id, synapse_id)
      VALUES (synapseId, neuronId, synapseId);
  END LOOP;
END
$$;

