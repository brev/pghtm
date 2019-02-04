/**
 * Cell Table
 */

CREATE TABLE htm.cell (
  id          SERIAL PRIMARY KEY,
  active      BOOL NOT NULL DEFAULT FALSE,
  active_last BOOL NOT NULL DEFAULT FALSE,
  column_id   INT NOT NULL,
  y_coord     INT NOT NULL,

  FOREIGN KEY (column_id)
    REFERENCES htm.column(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER SEQUENCE htm.cell_id_seq RESTART WITH 1;

