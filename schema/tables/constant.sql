/**
 * Constant Table
 */
CREATE TABLE htm.constant (
  id              INTEGER NOT NULL PRIMARY KEY DEFAULT (1),

  column_count     INTEGER NOT NULL,
  column_threshold INTEGER NOT NULL,
  dendrite_count   INTEGER NOT NULL, 
  input_width      INTEGER NOT NULL,
  neuron_count     INTEGER NOT NULL,
  potential_pct    NUMERIC NOT NULL,
  row_count        INTEGER NOT NULL,
  synapse_count    INTEGER NOT NULL,

  CHECK (id = 1)
);

