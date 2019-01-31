/**
 * Link: Axon from Cell to Synapse Data
 */

DO
$$
DECLARE
  segment_count CONSTANT INT := htm.config('segment_count');
  cell_count CONSTANT INT := htm.config('cell_count');
  synapse_count CONSTANT INT := htm.config('synapse_count');
  TotalSynapse CONSTANT INT := segment_count * cell_count * synapse_count;
  cellId INT;
BEGIN
  RAISE NOTICE 'Inserting % Links (Cell => Synapse)...', TotalSynapse;

  FOR synapseId IN 1..TotalSynapse LOOP
    cellId := htm.random_range_int(1, cell_count);
    INSERT
      INTO htm.link_distal_cell_synapse(id, cell_id, synapse_id)
      VALUES (synapseId, cellId, synapseId);
  END LOOP;
END
$$;

