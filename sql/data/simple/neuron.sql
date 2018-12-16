/**
 * Neuron
 */

DO 
$$
DECLARE
  CountColumn INT := htm.configInt('DataSimpleCountColumn');
  CountRow INT := htm.configInt('DataSimpleCountRow');
  neuronId INT;
BEGIN 
  FOR columnId IN 1..CountColumn LOOP
    FOR yCount IN 1..CountRow LOOP
      neuronId := htm.countUnloop(columnId, yCount, CountRow);
      INSERT 
        INTO htm.neuron (id, column_id, y_coord) 
        VALUES (neuronId, columnId, yCount);
    END LOOP;
  END LOOP;
END
$$;

