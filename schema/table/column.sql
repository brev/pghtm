/**
 * Column Table
 */

CREATE TABLE htm.column (
  id                  SERIAL PRIMARY KEY,
  active              BOOL NOT NULL DEFAULT FALSE,
  boost_factor        NUMERIC NOT NULL DEFAULT 0.0,
  duty_cycle_active   NUMERIC NOT NULL DEFAULT 1.0,
  duty_cycle_overlap  NUMERIC NOT NULL DEFAULT 1.0,
  region_id           INT NOT NULL,
  x_coord             INT NOT NULL,

  FOREIGN KEY (region_id)
    REFERENCES htm.region(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CHECK (boost_factor >= 0.0),
  CHECK ((duty_cycle_active >= 0.0) AND (duty_cycle_active <= 1.0)),
  CHECK ((duty_cycle_overlap >= 0.0) AND (duty_cycle_overlap <= 1.0))
);

ALTER SEQUENCE htm.column_id_seq RESTART WITH 1;

