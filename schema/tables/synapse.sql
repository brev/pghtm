CREATE TABLE htm.synapse (
  id          INT NOT NULL PRIMARY KEY,
  dendrite_id INT NOT NULL,
  permanence  NUMERIC(3,2) NOT NULL,

  CHECK ((permanence >= 0.00) AND (permanence <= 1.00)),
  FOREIGN KEY (dendrite_id)
    REFERENCES htm.dendrite(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

