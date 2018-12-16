
CREATE FUNCTION htm.dendrite_activation(synapse_count BIGINT)
RETURNS BOOL
AS $$
DECLARE
  ThresholdDendriteSynapse INT := htm.configInt('ThresholdDendriteSynapse');
BEGIN
  RETURN synapse_count >= ThresholdDendriteSynapse;
END;
$$ LANGUAGE plpgsql;

