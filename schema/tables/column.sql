/**
 * Column Table
 */
CREATE TABLE htm.column (
  id                INTEGER NOT NULL PRIMARY KEY,
  region_id         INTEGER NOT NULL, 
  x_coord           INTEGER NOT NULL,
  overlap           INTEGER NOT NULL,
  overlapDutyCycle  NUMERIC NOT NULL,

  CHECK ((overlapDutyCycle >= 0.0) AND (overlapDutyCycle <= 1.0)),
  FOREIGN KEY (region_id)
    REFERENCES htm.region(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

