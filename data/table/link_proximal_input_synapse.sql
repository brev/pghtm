/**
 * Link (Proximal): Axon from Input to Synapse Data
 */

DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
  synapse_count CONSTANT INT := htm.config('synapse_proximal_count');
  input_width CONSTANT INT := htm.config('input_width');
  linkId INT;
  localColumnId INT;
  localSynapseId INT;
BEGIN
  RAISE NOTICE 'Inserting % Proximal Links (Input => Synapse)...',
    (column_count * synapse_count);

  FOR localColumnId IN 1..column_count LOOP
    FOR localSynapseId IN 1..synapse_count LOOP
      linkId := htm.count_unloop(
        localColumnId,
        localSynapseId,
        synapse_count
      );
      INSERT
        INTO htm.link_proximal_input_synapse(input_index, synapse_id)
        VALUES (
          htm.random_range_int(1, input_width),
          linkId
        );
    END LOOP;
  END LOOP;
END
$$;

