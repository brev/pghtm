/**
 * Link Segment to Column Table
 */
CREATE TABLE htm.link_proximal_segment_column(
  id          SERIAL PRIMARY KEY,
  created     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  column_id   INT NOT NULL,
  segment_id  INT NOT NULL,

  FOREIGN KEY (segment_id)
    REFERENCES htm.segment(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (column_id)
    REFERENCES htm.column(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CHECK (id > 0),
  UNIQUE (segment_id, column_id)
);

