/** 
 * Dendrite Data
 */

DO
$$
DECLARE
  CountColumn INT := htm.config('CountColumn');
  CountDendrite INT := htm.config('CountDendrite');
  CountNeuron INT := htm.config('CountNeuron');
  dendriteId INT;
BEGIN
  FOR neuronId IN 1..CountNeuron LOOP
    FOR localId IN 1..CountDendrite LOOP
      dendriteId := htm.count_unloop(neuronId, localId, countDendrite);
      INSERT
        INTO htm.dendrite (id) 
        VALUES (dendriteId);
    END LOOP;
  END LOOP;

  FOR columnId IN 1..CountColumn LOOP
    INSERT
      INTO htm.dendrite (id) 
      VALUES (dendriteId + columnId);
  END LOOP;
END
$$;

