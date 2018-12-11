CREATE FUNCTION htm.dendrite_synapse_threshold()
RETURNS INT
AS $$ 
  BEGIN
    RETURN 3;
  END; 
$$ LANGUAGE plpgsql;

CREATE FUNCTION htm.dendrite_activation(synapse_count BIGINT)
RETURNS BOOL
AS $$
  BEGIN
    RETURN synapse_count >= htm.dendrite_synapse_threshold();
  END;
$$ LANGUAGE plpgsql;

