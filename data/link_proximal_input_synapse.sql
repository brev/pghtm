/**
 * Link: Axon from Input to Synapse Data
 */

DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
  dendrite_count CONSTANT INT := htm.config('dendrite_count');
  neuron_count CONSTANT INT := htm.config('neuron_count');
  synapse_count CONSTANT INT := htm.config('synapse_count');
  input_width CONSTANT INT := htm.config('input_width');
  SynapseStart CONSTANT INT := dendrite_count * neuron_count * synapse_count;
  linkId INT;
BEGIN
  RAISE NOTICE 'Inserting % Links (Input => Synapse)...',
    (column_count * synapse_count);

  FOR localColumnId IN 1..column_count LOOP
    FOR localSynapseId IN 1..synapse_count LOOP
      linkId := htm.count_unloop(
        localColumnId,
        localSynapseId,
        synapse_count
      );
      INSERT
        INTO htm.link_proximal_input_synapse(id, input_index, synapse_id)
        VALUES (
          linkId,
          htm.random_range_int(1, input_width),
          SynapseStart + linkId
        );
    END LOOP;
  END LOOP;
END
$$;

