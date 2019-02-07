/**
 * Region Table
 */
CREATE TABLE htm.region (
  id                      SERIAL PRIMARY KEY,
  duty_cycle_active_mean  NUMERIC NOT NULL DEFAULT 0.0,
  duty_cycle_overlap_mean NUMERIC NOT NULL DEFAULT 0.0,

  CHECK (
    (duty_cycle_active_mean >= 0.0) AND
    (duty_cycle_active_mean <= 1.0)
  ),
  CHECK (
    (duty_cycle_overlap_mean >= 0.0) AND
    (duty_cycle_overlap_mean <= 1.0)
  )
);

