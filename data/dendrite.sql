/** 
 * Dendrite Data
 */

DO
$$
DECLARE
  ColumnCount INT := htm.const('ColumnCount');
  DendriteCount INT := htm.const('DendriteCount');
  NeuronCount INT := htm.const('NeuronCount');
  dendriteId INT;
BEGIN
  RAISE NOTICE 'Inserting % Dendrites (Distal)...', 
    (NeuronCount * DendriteCount);

  FOR neuronId IN 1..NeuronCount LOOP
    FOR localId IN 1..DendriteCount LOOP
      dendriteId := htm.count_unloop(neuronId, localId, DendriteCount);
      INSERT
        INTO htm.dendrite (id, class)
        VALUES (dendriteId, 'distal');
    END LOOP;
  END LOOP;

  RAISE NOTICE 'Inserting % Dendrites (Proximal)...', ColumnCount;
  
  FOR columnId IN 1..ColumnCount LOOP
    INSERT
      INTO htm.dendrite (id, class)
      VALUES (dendriteId + columnId, 'proximal');
  END LOOP;
END
$$;

