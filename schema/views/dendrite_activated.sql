CREATE VIEW htm.dendrite_activated AS
  SELECT d.*
  FROM htm.dendrite d
  JOIN htm.synapse_connected sc
    ON sc.dendrite_id = d.id
  GROUP BY d.id, sc.dendrite_id
  HAVING htm.dendrite_activation(COUNT(sc.dendrite_id));

