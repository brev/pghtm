CREATE TABLE htm.column (
  id              INT NOT NULL PRIMARY KEY,
  region_id       INT NOT NULL, 
  x_coord         INT NOT NULL,
  activeDutyCycle NUMERIC NOT NULL,

  CHECK ((activeDutyCycle >= 0) AND (activeDutyCycle <= 1)),
  FOREIGN KEY (region_id)
    REFERENCES htm.region(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

