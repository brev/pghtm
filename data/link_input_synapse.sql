/**
 * Link: Axon from Input to Synapse Data
 */

DO
$$
DECLARE
  column_count INT := htm.const('column_count');
  dendrite_count INT := htm.const('dendrite_count');
  neuron_count INT := htm.const('neuron_count');
  synapse_count INT := htm.const('synapse_count');
  input_width INT := htm.const('input_width');
  SynapseStart INT := dendrite_count * neuron_count * synapse_count;
  linkId INT;
BEGIN
  RAISE NOTICE 'Inserting % Links (Input => Synapse)...', 
    (column_count * synapse_count);

  FOR localColumnId IN 1..column_count LOOP
    FOR localSynapseId IN 1..synapse_count LOOP
      linkId := htm.count_unloop(localColumnId, localSynapseId, synapse_count);
      INSERT
        INTO htm.link_input_synapse(id, input_index, synapse_id)
        VALUES (
          linkId, 
          htm.random_range_int(1, input_width), 
          SynapseStart + linkId
        );
    END LOOP;
  END LOOP;
END
$$;

