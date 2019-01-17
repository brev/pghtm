/**
 * Link: Dendrite to Column Data
 */

DO
$$
DECLARE
  column_count INT := htm.config('column_count');
  dendrite_count INT := htm.config('dendrite_count');
  neuron_count INT := htm.config('neuron_count');
  lastDendriteId INT := neuron_count * dendrite_count;
BEGIN
  RAISE NOTICE 'Inserting % Links (Dendrite => Column)...', column_count;
  
  FOR columnId IN 1..column_count LOOP
    INSERT
      INTO htm.link_dendrite_column (id, dendrite_id, column_id)
      VALUES (columnId, lastDendriteId + columnId, columnId);
  END LOOP;
END
$$;

