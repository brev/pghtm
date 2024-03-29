/**
 * Column Table
 */
CREATE TABLE htm.column (
  id                  SERIAL PRIMARY KEY,
  active              BOOL NOT NULL DEFAULT FALSE,
  boost_factor        NUMERIC NOT NULL DEFAULT 0.0,
  created             TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  duty_cycle_active   NUMERIC NOT NULL DEFAULT 1.0,
  duty_cycle_overlap  NUMERIC NOT NULL DEFAULT 1.0,
  modified            TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  region_id           INT NOT NULL,
  x_coord             INT NOT NULL,

  FOREIGN KEY (region_id)
    REFERENCES htm.region(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CHECK (id > 0),
  CHECK (boost_factor >= 0.0),
  CHECK ((duty_cycle_active >= 0.0) AND (duty_cycle_active <= 1.0)),
  CHECK ((duty_cycle_overlap >= 0.0) AND (duty_cycle_overlap <= 1.0))
);

