/**
 * Synapse Table
 */

CREATE TABLE htm.synapse (
  id          INT NOT NULL PRIMARY KEY,
  dendrite_id INT NOT NULL,
  permanence  NUMERIC NOT NULL,

  CHECK ((permanence >= 0) AND (permanence <= 1)),
  FOREIGN KEY (dendrite_id)
    REFERENCES htm.dendrite(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

