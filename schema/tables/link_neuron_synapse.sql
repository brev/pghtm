/**
 * Link Neuron to Synapse Table
 */

CREATE TABLE htm.link_neuron_synapse(
  id          INT NOT NULL PRIMARY KEY,
  neuron_id   INT NOT NULL,
  synapse_id  INT NOT NULL,

  FOREIGN KEY (neuron_id)
    REFERENCES htm.neuron(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (synapse_id)
    REFERENCES htm.synapse(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
