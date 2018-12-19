CREATE TABLE htm.column (
  id        INT NOT NULL PRIMARY KEY,
  region_id INT NOT NULL, 
  x_coord   INT NOT NULL,

  FOREIGN KEY (region_id)
    REFERENCES htm.region(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

