/**
 * Link Segment to Column Table
 */

CREATE TABLE htm.link_proximal_segment_column(
  id          SERIAL PRIMARY KEY,
  segment_id  INT NOT NULL,
  column_id   INT NOT NULL,

  FOREIGN KEY (segment_id)
    REFERENCES htm.segment(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (column_id)
    REFERENCES htm.column(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER SEQUENCE htm.link_proximal_segment_column_id_seq RESTART WITH 1;

