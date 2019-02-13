/**
 * Synapse (Proximal) Table
 * @SpatialPooler
 */
CREATE TABLE htm.synapse_proximal (
  id          SERIAL PRIMARY KEY,
  column_id   INT NOT NULL,
  created     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  input_index INT NOT NULL,
  modified    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  permanence  NUMERIC NOT NULL,

  CHECK (id > 0),
  CHECK ((permanence >= 0.0) AND (permanence <= 1.0)),
  UNIQUE (column_id, input_index),
  FOREIGN KEY (column_id)
    REFERENCES htm.column(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

