/**
 * Column Table
 */
CREATE TABLE htm.column (
  id                  INTEGER NOT NULL PRIMARY KEY,
  region_id           INTEGER NOT NULL, 
  x_coord             INTEGER NOT NULL,
  overlap_duty_cycle  NUMERIC NOT NULL,
  
  CHECK ((overlap_duty_cycle >= 0.0) AND (overlap_duty_cycle <= 1.0)),
  FOREIGN KEY (region_id)
    REFERENCES htm.region(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

