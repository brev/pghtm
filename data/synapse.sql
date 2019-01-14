/**
 * Synapse Data
 */

DO
$$
DECLARE
  ColumnCount INT := htm.const('ColumnCount');
  DendriteCount INT := htm.const('DendriteCount');
  NeuronCount INT := htm.const('NeuronCount');
  SynapseCount INT := htm.const('SynapseCount');
  dendriteId INT;
  synapseId INT;
BEGIN  
  -- fill distal synapses data
  FOR neuronId IN 1..NeuronCount LOOP
    FOR localDendriteId IN 1..DendriteCount LOOP
      dendriteId := htm.count_unloop(neuronId, localDendriteId, DendriteCount);
      FOR localSynapseId IN 1..SynapseCount LOOP
        synapseId := htm.count_unloop(dendriteId, localSynapseId, SynapseCount);
        INSERT 
          INTO htm.synapse (id, dendrite_id, permanence)
          VALUES (
            synapseId, 
            dendriteId, 
            htm.random_range_numeric((
              htm.var('SynapseThreshold')::NUMERIC - 
              htm.var('SynapseDecrement')::NUMERIC
            ), (
              htm.var('SynapseThreshold')::NUMERIC + 
              htm.var('SynapseIncrement')::NUMERIC
            ))
          );
      END LOOP;
    END LOOP;
  END LOOP;
  
  -- fill proximal synapses data
  FOR columnId IN 1..ColumnCount LOOP
    FOR localSynapseId IN 1..SynapseCount LOOP
      synapseId := htm.count_unloop(
        dendriteId + columnId, 
        localSynapseId, 
        SynapseCount
      );
      INSERT 
        INTO htm.synapse (id, dendrite_id, permanence)
        VALUES (
          synapseId, 
          dendriteId + columnId, 
          htm.random_range_numeric((
            htm.var('SynapseThreshold')::NUMERIC - 
            htm.var('SynapseDecrement')::NUMERIC
          ), (
            htm.var('SynapseThreshold')::NUMERIC + 
            htm.var('SynapseIncrement')::NUMERIC
          ))
        );
    END LOOP;
  END LOOP;
END
$$;

