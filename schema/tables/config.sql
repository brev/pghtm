/**
 * Config Table
 */
CREATE TABLE htm.config (
  id INTEGER NOT NULL PRIMARY KEY DEFAULT (1),

  boost_strength      NUMERIC NOT NULL,
  column_count        INTEGER NOT NULL, -- readonly
  column_threshold    INTEGER NOT NULL,
  dendrite_count      INTEGER NOT NULL, -- readonly
  dendrite_threshold  INTEGER NOT NULL,
  duty_cycle_period   INTEGER NOT NULL,
  inhibition          INTEGER NOT NULL,
  input_width         INTEGER NOT NULL, -- readonly
  logging             BOOLEAN NOT NULL,
  neuron_count        INTEGER NOT NULL, -- readonly
  potential_pct       NUMERIC NOT NULL,
  row_count           INTEGER NOT NULL, -- readonly
  sp_learn            BOOLEAN NOT NULL,
  synapse_count       INTEGER NOT NULL, -- readonly
  synapse_decrement   NUMERIC NOT NULL,
  synapse_increment   NUMERIC NOT NULL,
  synapse_threshold   NUMERIC NOT NULL,

  CHECK (id = 1)
);

