CREATE FUNCTION htm.synapse_permanence_threshold()
RETURNS NUMERIC
AS $$ 
  BEGIN
    RETURN 0.3;
  END; 
$$ LANGUAGE plpgsql;

CREATE FUNCTION htm.synapse_weight(permanence NUMERIC)
RETURNS BOOL
AS $$ 
  BEGIN
    RETURN permanence >= htm.synapse_permanence_threshold();
  END; 
$$ LANGUAGE plpgsql;

