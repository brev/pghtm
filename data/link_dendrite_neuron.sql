/** 
 * Link: Dendrite to Neuron Data
 */

DO
$$
DECLARE
  CountDendrite INT := htm.config('CountDendrite');
  CountNeuron INT := htm.config('CountNeuron');
  linkId INT;
BEGIN
  FOR neuronId IN 1..CountNeuron LOOP
    FOR dendriteId IN 1..CountDendrite LOOP
      linkId := htm.count_unloop(neuronId, dendriteId, CountDendrite);
      INSERT
        INTO htm.link_dendrite_neuron (id, dendrite_id, neuron_id) 
        VALUES (linkId, linkId, neuronId);
    END LOOP;
  END LOOP;
END
$$;
