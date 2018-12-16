/** 
 * Link: Dendrite to Neuron
 */

DO
$$
DECLARE
  CountDendrite INT := htm.configInt('DataSimpleCountDendrite');
  CountNeuron INT := htm.configInt('DataSimpleCountNeuron');
  linkId INT;
BEGIN
  FOR neuronId IN 1..CountNeuron LOOP
    FOR dendriteId IN 1..CountDendrite LOOP
      linkId := htm.countUnloop(neuronId, dendriteId, CountDendrite);
      INSERT
        INTO htm.link_dendrite_neuron (id, dendrite_id, neuron_id) 
        VALUES (linkId, linkId, neuronId);
    END LOOP;
  END LOOP;
END
$$;

