/**
 * Column Table
 */
CREATE TABLE htm.column (
  id                  INTEGER NOT NULL PRIMARY KEY,
  boost_factor        NUMERIC NOT NULL,
  duty_cycle_active   NUMERIC NOT NULL,
  duty_cycle_overlap  NUMERIC NOT NULL,
  region_id           INTEGER NOT NULL, 
  x_coord             INTEGER NOT NULL,
  
  FOREIGN KEY (region_id)
    REFERENCES htm.region(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CHECK (boost_factor >= 0.0),
  CHECK ((duty_cycle_active >= 0.0) AND (duty_cycle_active <= 1.0)),
  CHECK ((duty_cycle_overlap >= 0.0) AND (duty_cycle_overlap <= 1.0))
);

