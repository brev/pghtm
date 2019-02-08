/**
 * Link Input to Synapse Table
 */
CREATE TABLE htm.link_proximal_input_synapse(
  id          SERIAL PRIMARY KEY,
  input_index INT NOT NULL,
  synapse_id  INT NOT NULL,

  FOREIGN KEY (synapse_id)
    REFERENCES htm.synapse(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  UNIQUE (input_index, synapse_id)
);

