/**
 * Synapse
 */

DO
$$
DECLARE
  CountColumn INT := htm.config_int('DataSimpleCountColumn');
  CountDendrite INT := htm.config_int('DataSimpleCountDendrite');
  CountNeuron INT := htm.config_int('DataSimpleCountNeuron');
  CountSynapse INT := htm.config_int('DataSimpleCountSynapse');
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
          VALUES (synapseId, dendriteId, 0.00);
      END LOOP;
    END LOOP;
  END LOOP;
  
  FOR columnId IN 1..CountColumn LOOP
    FOR localSynapseId IN 1..CountSynapse LOOP
      synapseId := htm.count_unloop(dendriteId + columnId, localSynapseId, CountSynapse);
      INSERT 
        INTO htm.synapse (id, dendrite_id, permanence) 
        VALUES (synapseId, dendriteId + columnId, 0.00);
    END LOOP;
  END LOOP;
END
$$;

