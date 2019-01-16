/**
 * Synapse Data
 */

DO
$$
DECLARE
  column_count INT := htm.const('column_count');
  dendrite_count INT := htm.const('dendrite_count');
  neuron_count INT := htm.const('neuron_count');
  synapse_count INT := htm.const('synapse_count');
  dendriteId INT;
  synapseId INT;
BEGIN  
  -- fill distal synapses data
  RAISE NOTICE 'Inserting % Synapses (Distal)...', 
    (neuron_count * dendrite_count * synapse_count);

  FOR neuronId IN 1..neuron_count LOOP
    FOR localDendriteId IN 1..dendrite_count LOOP
      dendriteId := htm.count_unloop(neuronId, localDendriteId, dendrite_count);
      FOR localSynapseId IN 1..synapse_count LOOP
        synapseId := htm.count_unloop(dendriteId, localSynapseId, synapse_count);
        INSERT 
          INTO htm.synapse (id, dendrite_id, permanence)
          VALUES (
            synapseId, 
            dendriteId, 
            htm.random_range_numeric((
              htm.var('synapse_threshold')::NUMERIC - 
              htm.var('synapse_decrement')::NUMERIC
            ), (
              htm.var('synapse_threshold')::NUMERIC + 
              htm.var('synapse_increment')::NUMERIC
            ))
          );
      END LOOP;
    END LOOP;
  END LOOP;
  
  -- fill proximal synapses data
  RAISE NOTICE 'Inserting % Synapses (Proximal)...', 
    (column_count * synapse_count);

  FOR columnId IN 1..column_count LOOP
    FOR localSynapseId IN 1..synapse_count LOOP
      synapseId := htm.count_unloop(
        dendriteId + columnId, 
        localSynapseId, 
        synapse_count
      );
      INSERT 
        INTO htm.synapse (id, dendrite_id, permanence)
        VALUES (
          synapseId, 
          dendriteId + columnId, 
          htm.random_range_numeric((
            htm.var('synapse_threshold')::NUMERIC - 
            htm.var('synapse_decrement')::NUMERIC
          ), (
            htm.var('synapse_threshold')::NUMERIC + 
            htm.var('synapse_increment')::NUMERIC
          ))
        );
    END LOOP;
  END LOOP;
END
$$;

