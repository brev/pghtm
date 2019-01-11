/**
 * Region Table
 */
CREATE TABLE htm.region (
  id                      INTEGER NOT NULL PRIMARY KEY,
  boost_factor_max        NUMERIC NOT NULL,
  boost_factor_min        NUMERIC NOT NULL,
  duty_cycle_active_max   NUMERIC NOT NULL,
  duty_cycle_active_mean  NUMERIC NOT NULL,
  duty_cycle_active_min   NUMERIC NOT NULL,

  CHECK (boost_factor_max >= 0.0),
  CHECK (boost_factor_min >= 0.0),
  CHECK ((duty_cycle_active_max >= 0.0) AND (duty_cycle_active_max <= 1.0)),
  CHECK ((duty_cycle_active_mean >= 0.0) AND (duty_cycle_active_mean <= 1.0)),
  CHECK ((duty_cycle_active_min >= 0.0) AND (duty_cycle_active_min <= 1.0))
);

