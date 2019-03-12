/**
 * Synapse (Proximal) Data
 */

DO
$$
DECLARE
  column_count CONSTANT INT := htm.config('column_count');
  input_width CONSTANT INT := htm.config('input_width');
  synapse_proximal_count CONSTANT INT := htm.config('synapse_proximal_count');
  input_targets INT[];
  input_index_id INT;
BEGIN
  -- fill static proximal synapses data for the SP algo/functions
  FOR column_id IN 1..column_count LOOP
    -- reset possible input list for each column
    SELECT ARRAY(
      SELECT GENERATE_SERIES(1, input_width)
    ) INTO input_targets;

    FOR synapse_id IN 1..synapse_proximal_count LOOP
      -- pop a random input_index off the list
      input_index_id := input_targets[
        htm.random_range_int(1, COALESCE(ARRAY_LENGTH(input_targets, 1), 0))
      ];
      input_targets := ARRAY_REMOVE(input_targets, input_index_id);
      -- grow synapse
      INSERT
        INTO htm.synapse_proximal (column_id, input_index, permanence)
        VALUES (
          column_id,
          input_index_id,
          htm.random_range_numeric((
            htm.config('synapse_proximal_threshold')::NUMERIC -
            htm.config('synapse_proximal_decrement')::NUMERIC
          ), (
            htm.config('synapse_proximal_threshold')::NUMERIC +
            htm.config('synapse_proximal_increment')::NUMERIC
          ))
        );
    END LOOP;
  END LOOP;
END
$$;

