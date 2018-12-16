
CREATE FUNCTION htm.synapse_weight(permanence NUMERIC)
RETURNS BOOL
AS $$ 
DECLARE
  ThresholdSynapsePermanence INT := htm.configNumeric('ThresholdSynapsePermanence');
BEGIN
  RETURN permanence >= ThresholdSynapsePermanence;
END; 
$$ LANGUAGE plpgsql;

