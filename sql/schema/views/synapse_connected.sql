CREATE VIEW htm.synapse_connected AS
  SELECT s.* 
  FROM htm.synapse s
  WHERE htm.synapse_weight(s.permanence);

