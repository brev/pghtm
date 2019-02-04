/**
 * Link Input to Synapse Table
 */

CREATE TABLE htm.link_proximal_input_synapse(
  id          SERIAL PRIMARY KEY,
  input_index INT NOT NULL,
  synapse_id  INT NOT NULL,

  UNIQUE(input_index, synapse_id),
  FOREIGN KEY (synapse_id)
    REFERENCES htm.synapse(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER SEQUENCE htm.link_proximal_input_synapse_id_seq RESTART WITH 1;

