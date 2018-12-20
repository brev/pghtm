CREATE VIEW htm.neuron_activated AS
  SELECT n.*
  FROM htm.neuron n
  JOIN htm.link_dendrite_neuron ldn
    ON ldn.neuron_id = n.id
  JOIN htm.dendrite_activated da
    ON da.id = ldn.dendrite_id
  GROUP BY n.id;

