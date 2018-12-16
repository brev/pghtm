/**
 * Synapse
 */

DO
$$
DECLARE
  CountColumn INT := htm.configInt('DataSimpleCountColumn');
  CountDendrite INT := htm.configInt('DataSimpleCountDendrite');
  CountNeuron INT := htm.configInt('DataSimpleCountNeuron');
  CountSynapse INT := htm.configInt('DataSimpleCountSynapse');
  dendriteId INT;
  synapseId INT;
BEGIN
  FOR neuronId IN 1..CountNeuron LOOP
    FOR localDendriteId IN 1..CountDendrite LOOP
      dendriteId := htm.countUnloop(neuronId, localDendriteId, CountDendrite);
      FOR localSynapseId IN 1..CountSynapse LOOP
        synapseId := htm.countUnloop(dendriteId, localSynapseId, CountSynapse);
        INSERT 
          INTO htm.synapse (id, dendrite_id, permanence) 
          VALUES (synapseId, dendriteId, RANDOM());
      END LOOP;
    END LOOP;
  END LOOP;
  
  FOR columnId IN 1..CountColumn LOOP
    FOR localSynapseId IN 1..CountSynapse LOOP
      synapseId := htm.countUnloop(dendriteId + columnId, localSynapseId, CountSynapse);
      INSERT 
        INTO htm.synapse (id, dendrite_id, permanence) 
        VALUES (synapseId, dendriteId + columnId, RANDOM());
    END LOOP;
  END LOOP;
END
$$;

