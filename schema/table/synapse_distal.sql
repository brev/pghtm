/**
 * Synapse (Distal) Table
 * @TemporalMemory
 */
CREATE TABLE htm.synapse_distal (
  id            SERIAL PRIMARY KEY,
  created       TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  input_cell_id INT NOT NULL,
  modified      TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  permanence    NUMERIC NOT NULL,
  segment_id    INT NOT NULL,

  CHECK (id > 0),
  CHECK ((permanence >= 0.0) AND (permanence <= 1.0)),
  UNIQUE (input_cell_id, segment_id),
  FOREIGN KEY (input_cell_id)
    REFERENCES htm.cell(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (segment_id)
    REFERENCES htm.segment(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

