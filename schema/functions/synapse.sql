
CREATE FUNCTION htm.synapse_weight(permanence NUMERIC)
RETURNS BOOL
AS $$ 
DECLARE
  ThresholdSynapsePermanence NUMERIC := htm.config_numeric('ThresholdSynapsePermanence');
BEGIN
  RETURN permanence >= ThresholdSynapsePermanence;
END; 
$$ LANGUAGE plpgsql;

