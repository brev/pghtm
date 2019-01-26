/**
 * Link Dendrite to Neuron Table
 */
CREATE TABLE htm.link_distal_dendrite_neuron(
  id          INT NOT NULL PRIMARY KEY,
  dendrite_id INT NOT NULL,
  neuron_id   INT NOT NULL,

  FOREIGN KEY (dendrite_id)
    REFERENCES htm.dendrite(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (neuron_id)
    REFERENCES htm.neuron(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

