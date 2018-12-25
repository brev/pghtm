
CREATE FUNCTION htm.synapse_weight(permanence NUMERIC)
RETURNS BOOL
AS $$ 
DECLARE
  connectedPerm NUMERIC := htm.config('connectedPerm');
BEGIN
  RETURN permanence > connectedPerm;
END; 
$$ LANGUAGE plpgsql;

