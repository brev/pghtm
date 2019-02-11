/**
 * Link Cell to Synapse Table
 */
CREATE TABLE htm.link_distal_cell_synapse(
  id          SERIAL PRIMARY KEY,
  cell_id     INT NOT NULL,
  created     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  synapse_id  INT NOT NULL,

  FOREIGN KEY (cell_id)
    REFERENCES htm.cell(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (synapse_id)
    REFERENCES htm.synapse(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CHECK (id > 0),
  UNIQUE (cell_id, synapse_id)
);

