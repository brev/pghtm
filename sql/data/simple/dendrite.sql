/** 
 * Dendrite
 */

DO
$$
DECLARE
  CountColumn INT := htm.configInt('DataSimpleCountColumn');
  CountDendrite INT := htm.configInt('DataSimpleCountDendrite');
  CountNeuron INT := htm.configInt('DataSimpleCountNeuron');
  dendriteId INT;
BEGIN
  FOR neuronId IN 1..CountNeuron LOOP
    FOR localId IN 1..CountDendrite LOOP
      dendriteId := htm.countUnloop(neuronId, localId, countDendrite);
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

