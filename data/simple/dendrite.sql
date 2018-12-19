/** 
 * Dendrite
 */

DO
$$
DECLARE
  CountColumn INT := htm.config_int('DataSimpleCountColumn');
  CountDendrite INT := htm.config_int('DataSimpleCountDendrite');
  CountNeuron INT := htm.config_int('DataSimpleCountNeuron');
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

