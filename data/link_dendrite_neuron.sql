/** 
 * Link: Dendrite to Neuron Data
 */

DO
$$
DECLARE
  DendriteCount INT := htm.config('DendriteCount');
  NeuronCount INT := htm.config('NeuronCount');
  linkId INT;
BEGIN
  FOR neuronId IN 1..NeuronCount LOOP
    FOR dendriteId IN 1..DendriteCount LOOP
      linkId := htm.count_unloop(neuronId, dendriteId, DendriteCount);
      INSERT
        INTO htm.link_dendrite_neuron (id, dendrite_id, neuron_id) 
        VALUES (linkId, linkId, neuronId);
    END LOOP;
  END LOOP;
END
$$;

