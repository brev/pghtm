/**
 * Link: Dendrite to Column Data
 */

DO
$$
DECLARE
  ColumnCount INT := htm.config('ColumnCount');
  DendriteCount INT := htm.config('DendriteCount');
  NeuronCount INT := htm.config('NeuronCount');
  lastDendriteId INT := NeuronCount * DendriteCount;
BEGIN
  FOR columnId IN 1..ColumnCount LOOP
    INSERT
      INTO htm.link_dendrite_column (id, dendrite_id, column_id)
      VALUES (columnId, lastDendriteId + columnId, columnId);
  END LOOP;
END
$$;

