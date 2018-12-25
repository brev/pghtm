/**
 * Neuron Table
 */

CREATE TABLE htm.neuron (
  id        INT NOT NULL PRIMARY KEY,
  column_id INT NOT NULL,
  y_coord   INT NOT NULL,

  FOREIGN KEY (column_id)
    REFERENCES htm.column(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

