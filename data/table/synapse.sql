/**
 * Synapse Data
 */

DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
  segment_count CONSTANT INT := htm.config('segment_count');
  cell_count CONSTANT INT := htm.config('cell_count');
  synapse_count CONSTANT INT := htm.config('synapse_count');
  segmentId INT;
  synapseId INT;
BEGIN
  -- fill distal synapses data
  RAISE NOTICE 'Inserting % Synapses (Distal)...',
    (cell_count * segment_count * synapse_count);

  FOR cellId IN 1..cell_count LOOP
    FOR localSegmentId IN 1..segment_count LOOP
      segmentId := htm.count_unloop(
        cellId,
        localSegmentId,
        segment_count
      );
      FOR localSynapseId IN 1..synapse_count LOOP
        synapseId := htm.count_unloop(
          segmentId,
          localSynapseId,
          synapse_count
        );
        INSERT
          INTO htm.synapse (id, segment_id, permanence)
          VALUES (
            synapseId,
            segmentId,
            htm.random_range_numeric((
              htm.config('synapse_distal_threshold')::NUMERIC -
              htm.config('synapse_distal_decrement')::NUMERIC
            ), (
              htm.config('synapse_distal_threshold')::NUMERIC +
              htm.config('synapse_distal_increment')::NUMERIC
            ))
          );
      END LOOP;
    END LOOP;
  END LOOP;

  -- fill proximal synapses data
  RAISE NOTICE 'Inserting % Synapses (Proximal)...',
    (column_count * synapse_count);

  FOR columnId IN 1..column_count LOOP
    FOR localSynapseId IN 1..synapse_count LOOP
      synapseId := htm.count_unloop(
        segmentId + columnId,
        localSynapseId,
        synapse_count
      );
      INSERT
        INTO htm.synapse (id, segment_id, permanence)
        VALUES (
          synapseId,
          segmentId + columnId,
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

