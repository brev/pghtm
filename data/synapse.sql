/**
 * Synapse Data
 */

DO
$$
DECLARE
  ColumnCount INT := htm.config('ColumnCount');
  DendriteCount INT := htm.config('DendriteCount');
  NeuronCount INT := htm.config('NeuronCount');
  SynapseCount INT := htm.config('SynapseCount');
  dendriteId INT;
  synapseId INT;
BEGIN
  -- disable triggers on table for speedy initial data fill
  ALTER TABLE htm.synapse DISABLE TRIGGER USER;
  
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
              htm.config('SynapseThreshold')::NUMERIC - 
              htm.config('SynapseDecrement')::NUMERIC
            ), (
              htm.config('SynapseThreshold')::NUMERIC + 
              htm.config('SynapseIncrement')::NUMERIC
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
            htm.config('SynapseThreshold')::NUMERIC - 
            htm.config('SynapseDecrement')::NUMERIC
          ), (
            htm.config('SynapseThreshold')::NUMERIC + 
            htm.config('SynapseIncrement')::NUMERIC
          ))
        );
    END LOOP;
  END LOOP;
  
  -- re-enable triggers on table for normal functioning
  ALTER TABLE htm.synapse ENABLE TRIGGER USER;

  -- cause recently missed triggers to re-fire on entire new dataset at once
  UPDATE htm.synapse SET permanence = permanence;
END
$$;

