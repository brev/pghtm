/**
 * Constant Table
 */
CREATE TABLE htm.constant (
  id              INTEGER NOT NULL PRIMARY KEY DEFAULT (1),

  columncount     INTEGER NOT NULL,
  columnthreshold INTEGER NOT NULL,
  dendritecount   INTEGER NOT NULL, 
  inputwidth      INTEGER NOT NULL,
  neuroncount     INTEGER NOT NULL,
  potentialpct    NUMERIC NOT NULL,
  rowcount        INTEGER NOT NULL,
  synapsecount    INTEGER NOT NULL,

  CHECK (id = 1)
);

