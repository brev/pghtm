/**
 * Variables Table
 */
CREATE TABLE htm.variable (
  id                INTEGER NOT NULL PRIMARY KEY DEFAULT (1),

  booststrength     NUMERIC NOT NULL,
  dendritethreshold INTEGER NOT NULL,
  dutycycleperiod   INTEGER NOT NULL,
  inhibition        INTEGER NOT NULL,
  splearn           INTEGER NOT NULL,
  synapsedecrement  NUMERIC NOT NULL,
  synapseincrement  NUMERIC NOT NULL,
  synapsethreshold  NUMERIC NOT NULL,
  
  CHECK (id = 1)
);

