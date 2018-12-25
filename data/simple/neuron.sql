/**
 * Neuron Data
 */

DO 
$$
DECLARE
  CountColumn INT := htm.config('CountColumn');
  CountRow INT := htm.config('CountRow');
  neuronId INT;
BEGIN 
  FOR columnId IN 1..CountColumn LOOP
    FOR yCount IN 1..CountRow LOOP
      neuronId := htm.count_unloop(columnId, yCount, CountRow);
      INSERT 
        INTO htm.neuron (id, column_id, y_coord) 
        VALUES (neuronId, columnId, yCount);
    END LOOP;
  END LOOP;
END
$$;

