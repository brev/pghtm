/**
 * Synapse Data
 */

DO
$$
DECLARE
  CountColumn INT := htm.config('CountColumn');
  CountDendrite INT := htm.config('CountDendrite');
  CountNeuron INT := htm.config('CountNeuron');
  CountSynapse INT := htm.config('CountSynapse');
  dendriteId INT;
  synapseId INT;
BEGIN
  FOR neuronId IN 1..CountNeuron LOOP
    FOR localDendriteId IN 1..CountDendrite LOOP
      dendriteId := htm.count_unloop(neuronId, localDendriteId, CountDendrite);
      FOR localSynapseId IN 1..CountSynapse LOOP
        synapseId := htm.count_unloop(dendriteId, localSynapseId, CountSynapse);
        INSERT 
          INTO htm.synapse (id, dendrite_id, permanence) 
          VALUES (
            synapseId, 
            dendriteId, 
            htm.random_range_numeric((
              htm.config('ThresholdSynapse')::NUMERIC - 
              htm.config('SynapseDecrement')::NUMERIC
            ), (
              htm.config('ThresholdSynapse')::NUMERIC + 
              htm.config('SynapseIncrement')::NUMERIC
            ))
          );
      END LOOP;
    END LOOP;
  END LOOP;
  
  FOR columnId IN 1..CountColumn LOOP
    FOR localSynapseId IN 1..CountSynapse LOOP
      synapseId := htm.count_unloop(
        dendriteId + columnId, 
        localSynapseId, 
        CountSynapse
      );
      INSERT 
        INTO htm.synapse (id, dendrite_id, permanence) 
        VALUES (
          synapseId, 
          dendriteId + columnId, 
          htm.random_range_numeric((
            htm.config('ThresholdSynapse')::NUMERIC - 
            htm.config('SynapseDecrement')::NUMERIC
          ), (
            htm.config('ThresholdSynapse')::NUMERIC + 
            htm.config('SynapseIncrement')::NUMERIC
          ))
        );
    END LOOP;
  END LOOP;
END
$$;

