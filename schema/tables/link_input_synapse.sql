/**
 * Link Input to Synapse Table
 */

CREATE TABLE htm.link_input_synapse(
  id          INT NOT NULL PRIMARY KEY,
  input_index INT NOT NULL,
  synapse_id  INT NOT NULL,

  FOREIGN KEY (synapse_id)
    REFERENCES htm.synapse(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

