/**
 * Synapse Data
 */

DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
  dendrite_count CONSTANT INT := htm.config('dendrite_count');
  neuron_count CONSTANT INT := htm.config('neuron_count');
  synapse_count CONSTANT INT := htm.config('synapse_count');
  dendriteId INT;
  synapseId INT;
BEGIN
  -- fill distal synapses data
  RAISE NOTICE 'Inserting % Synapses (Distal)...',
    (neuron_count * dendrite_count * synapse_count);

  FOR neuronId IN 1..neuron_count LOOP
    FOR localDendriteId IN 1..dendrite_count LOOP
      dendriteId := htm.count_unloop(
        neuronId,
        localDendriteId,
        dendrite_count
      );
      FOR localSynapseId IN 1..synapse_count LOOP
        synapseId := htm.count_unloop(
          dendriteId,
          localSynapseId,
          synapse_count
        );
        INSERT
          INTO htm.synapse (id, dendrite_id, permanence)
          VALUES (
            synapseId,
            dendriteId,
            htm.random_range_numeric((
              htm.config('synapse_proximal_threshold')::NUMERIC -
              htm.config('synapse_proximal_decrement')::NUMERIC
            ), (
              htm.config('synapse_proximal_threshold')::NUMERIC +
              htm.config('synapse_proximal_increment')::NUMERIC
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
            htm.config('synapse_proximal_threshold')::NUMERIC -
            htm.config('synapse_proximal_decrement')::NUMERIC
          ), (
            htm.config('synapse_proximal_threshold')::NUMERIC +
            htm.config('synapse_proximal_increment')::NUMERIC
          ))
        );
    END LOOP;
  END LOOP;
END
$$;

