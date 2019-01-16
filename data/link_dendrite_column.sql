/**
 * Link: Dendrite to Column Data
 */

DO
$$
DECLARE
  ColumnCount INT := htm.const('ColumnCount');
  DendriteCount INT := htm.const('DendriteCount');
  NeuronCount INT := htm.const('NeuronCount');
  lastDendriteId INT := NeuronCount * DendriteCount;
BEGIN
  RAISE NOTICE 'Inserting % Links (Dendrite => Column)...', ColumnCount;
  
  FOR columnId IN 1..ColumnCount LOOP
    INSERT
      INTO htm.link_dendrite_column (id, dendrite_id, column_id)
      VALUES (columnId, lastDendriteId + columnId, columnId);
  END LOOP;
END
$$;

