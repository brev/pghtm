/**
 * Cell Table
 */
CREATE TABLE htm.cell (
  id          SERIAL PRIMARY KEY,
  active      BOOL NOT NULL DEFAULT FALSE,
  active_last BOOL NOT NULL DEFAULT FALSE,
  column_id   INT NOT NULL,
  created     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  modified    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  y_coord     INT NOT NULL,

  FOREIGN KEY (column_id)
    REFERENCES htm.column(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CHECK (id > 0)
);

