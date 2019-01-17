/** 
 * Link: Dendrite to Neuron Data
 */

DO
$$
DECLARE
  dendrite_count INT := htm.config('dendrite_count');
  neuron_count INT := htm.config('neuron_count');
  linkId INT;
BEGIN
  RAISE NOTICE 'Inserting % Links (Dendrite => Neuron)...', 
    (neuron_count * dendrite_count);
  
  FOR neuronId IN 1..neuron_count LOOP
    FOR dendriteId IN 1..dendrite_count LOOP
      linkId := htm.count_unloop(neuronId, dendriteId, dendrite_count);
      INSERT
        INTO htm.link_dendrite_neuron (id, dendrite_id, neuron_id) 
        VALUES (linkId, linkId, neuronId);
    END LOOP;
  END LOOP;
END
$$;

