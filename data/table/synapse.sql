/**
 * Synapse Data
 */

DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
  synapse_count CONSTANT INT := htm.config('synapse_count');
  synapseId INT;
BEGIN
  -- distal synapses are filled as part of the TM algo/functions

  -- fill static proximal synapses data for the SP algo/functions
  RAISE NOTICE 'Inserting % Synapses (Proximal)...',
    (column_count * synapse_count);

  FOR columnId IN 1..column_count LOOP
    FOR localSynapseId IN 1..synapse_count LOOP
      synapseId := htm.count_unloop(
        columnId,
        localSynapseId,
        synapse_count
      );
      INSERT
        INTO htm.synapse (id, segment_id, permanence)
        VALUES (
          synapseId,
          columnId,
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

