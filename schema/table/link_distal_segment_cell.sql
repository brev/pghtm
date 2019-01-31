/**
 * Link Segment to Cell Table
 */
CREATE TABLE htm.link_distal_segment_cell(
  id          INT NOT NULL PRIMARY KEY,
  segment_id INT NOT NULL,
  cell_id   INT NOT NULL,

  FOREIGN KEY (segment_id)
    REFERENCES htm.segment(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (cell_id)
    REFERENCES htm.cell(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

