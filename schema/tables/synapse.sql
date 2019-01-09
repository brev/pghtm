/**
 * Synapse Table
 */
CREATE TABLE htm.synapse (
  id          INTEGER NOT NULL PRIMARY KEY,
  dendrite_id INTEGER NOT NULL,
  permanence  NUMERIC NOT NULL,

  CHECK ((permanence >= 0.0) AND (permanence <= 1.0)),
  FOREIGN KEY (dendrite_id)
    REFERENCES htm.dendrite(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

