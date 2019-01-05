/**
 * Link Dendrite to Column Table
 */
CREATE TABLE htm.link_dendrite_column(
  id          INT NOT NULL PRIMARY KEY,
  dendrite_id INT NOT NULL,
  column_id   INT NOT NULL,

  FOREIGN KEY (dendrite_id)
    REFERENCES htm.dendrite(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (column_id)
    REFERENCES htm.column(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

