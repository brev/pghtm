/** 
 * Dendrite Data
 */

DO
$$
DECLARE
  column_count INT := htm.const('column_count');
  dendrite_count INT := htm.const('dendrite_count');
  neuron_count INT := htm.const('neuron_count');
  dendriteId INT;
BEGIN
  RAISE NOTICE 'Inserting % Dendrites (Distal)...', 
    (neuron_count * dendrite_count);

  FOR neuronId IN 1..neuron_count LOOP
    FOR localId IN 1..dendrite_count LOOP
      dendriteId := htm.count_unloop(neuronId, localId, dendrite_count);
      INSERT
        INTO htm.dendrite (id, class)
        VALUES (dendriteId, 'distal');
    END LOOP;
  END LOOP;

  RAISE NOTICE 'Inserting % Dendrites (Proximal)...', column_count;
  
  FOR columnId IN 1..column_count LOOP
    INSERT
      INTO htm.dendrite (id, class)
      VALUES (dendriteId + columnId, 'proximal');
  END LOOP;
END
$$;

