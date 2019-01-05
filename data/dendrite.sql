/** 
 * Dendrite Data
 */

DO
$$
DECLARE
  ColumnCount INT := htm.config('ColumnCount');
  DendriteCount INT := htm.config('DendriteCount');
  NeuronCount INT := htm.config('NeuronCount');
  dendriteId INT;
BEGIN
  FOR neuronId IN 1..NeuronCount LOOP
    FOR localId IN 1..DendriteCount LOOP
      dendriteId := htm.count_unloop(neuronId, localId, countDendrite);
      INSERT
        INTO htm.dendrite (id) 
        VALUES (dendriteId);
    END LOOP;
  END LOOP;

  FOR columnId IN 1..ColumnCount LOOP
    INSERT
      INTO htm.dendrite (id) 
      VALUES (dendriteId + columnId);
  END LOOP;
END
$$;

