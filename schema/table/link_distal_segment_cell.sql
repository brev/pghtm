/**
 * Link Segment to Cell Table
 */
CREATE TABLE htm.link_distal_segment_cell(
  id          SERIAL PRIMARY KEY,
  cell_id     INT NOT NULL,
  created     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  segment_id  INT NOT NULL,

  FOREIGN KEY (segment_id)
    REFERENCES htm.segment(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (cell_id)
    REFERENCES htm.cell(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CHECK (id > 0),
  UNIQUE (segment_id, cell_id)
);

