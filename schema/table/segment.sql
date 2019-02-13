/**
 * Segment Table
 */
CREATE TABLE htm.segment (
  id      SERIAL PRIMARY KEY,
  cell_id INT NOT NULL,
  created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

  CHECK (id > 0),
  FOREIGN KEY (cell_id)
    REFERENCES htm.cell(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

