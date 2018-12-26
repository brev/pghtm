
CREATE FUNCTION htm.synapse_weight(permanence NUMERIC)
RETURNS BOOL
AS $$ 
DECLARE
  ThresholdSynapse NUMERIC := htm.config('ThresholdSynapse');
BEGIN
  RETURN permanence > ThresholdSynapse;
END; 
$$ LANGUAGE plpgsql;

