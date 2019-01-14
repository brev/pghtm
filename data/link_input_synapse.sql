/**
 * Link: Axon from Input to Synapse Data
 */

DO
$$
DECLARE
  ColumnCount INT := htm.const('ColumnCount');
  DendriteCount INT := htm.const('DendriteCount');
  NeuronCount INT := htm.const('NeuronCount');
  SynapseCount INT := htm.const('SynapseCount');
  InputWidth INT := htm.const('InputWidth');
  SynapseStart INT := DendriteCount * NeuronCount * SynapseCount;
  linkId INT;
BEGIN
  FOR localColumnId IN 1..ColumnCount LOOP
    FOR localSynapseId IN 1..SynapseCount LOOP
      linkId := htm.count_unloop(localColumnId, localSynapseId, SynapseCount);
      INSERT
        INTO htm.link_input_synapse(id, input_index, synapse_id)
        VALUES (
          linkId, 
          htm.random_range_int(1, InputWidth), 
          SynapseStart + linkId
        );
    END LOOP;
  END LOOP;
END
$$;

