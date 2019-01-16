/**
 * Neuron Data
 */

DO 
$$
DECLARE
  column_count INT := htm.const('column_count');
  row_count INT := htm.const('row_count');
  neuronId INT;
BEGIN 
  RAISE NOTICE 'Inserting % Neurons...', (column_count * row_count);

  FOR columnId IN 1..column_count LOOP
    FOR yCount IN 1..row_count LOOP
      neuronId := htm.count_unloop(columnId, yCount, row_count);
      INSERT 
        INTO htm.neuron (id, column_id, y_coord) 
        VALUES (neuronId, columnId, yCount);
    END LOOP;
  END LOOP;
END
$$;

