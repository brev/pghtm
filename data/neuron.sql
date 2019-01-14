/**
 * Neuron Data
 */

DO 
$$
DECLARE
  ColumnCount INT := htm.const('ColumnCount');
  RowCount INT := htm.const('RowCount');
  neuronId INT;
BEGIN 
  FOR columnId IN 1..ColumnCount LOOP
    FOR yCount IN 1..RowCount LOOP
      neuronId := htm.count_unloop(columnId, yCount, RowCount);
      INSERT 
        INTO htm.neuron (id, column_id, y_coord) 
        VALUES (neuronId, columnId, yCount);
    END LOOP;
  END LOOP;
END
$$;

