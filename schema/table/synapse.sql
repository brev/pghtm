/**
 * Synapse Table
 */
CREATE TABLE htm.synapse (
  id          SERIAL PRIMARY KEY,
  created     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  modified    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  permanence  NUMERIC NOT NULL,
  segment_id  INT NOT NULL,

  CHECK (id > 0),
  CHECK ((permanence >= 0.0) AND (permanence <= 1.0)),
  FOREIGN KEY (segment_id)
    REFERENCES htm.segment(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

