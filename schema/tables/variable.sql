/**
 * Variables Table
 */
CREATE TABLE htm.variable (
  id                  INTEGER NOT NULL PRIMARY KEY DEFAULT (1),
  boost_strength      NUMERIC NOT NULL,
  dendrite_threshold  INTEGER NOT NULL,
  duty_cycle_period   INTEGER NOT NULL,
  inhibition          INTEGER NOT NULL,
  logging             BOOLEAN NOT NULL,
  sp_learn            INTEGER NOT NULL,
  synapse_decrement   NUMERIC NOT NULL,
  synapse_increment   NUMERIC NOT NULL,
  synapse_threshold   NUMERIC NOT NULL,
  
  CHECK (id = 1)
);

