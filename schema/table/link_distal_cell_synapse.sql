/**
 * Link Cell to Synapse Table
 */
CREATE TABLE htm.link_distal_cell_synapse(
  id          SERIAL PRIMARY KEY,
  cell_id     INT NOT NULL,
  synapse_id  INT NOT NULL,

  FOREIGN KEY (cell_id)
    REFERENCES htm.cell(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (synapse_id)
    REFERENCES htm.synapse(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

