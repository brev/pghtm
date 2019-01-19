/**
 * Input/SDR Table
 */
CREATE TABLE htm.input (
  id        SERIAL PRIMARY KEY,
  created   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  modified  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

  -- @SpatialPooler input
  ts      TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  indexes INT[] NOT NULL,
  -- @SpatialPooler output
  columns_active INT[]  -- NULL OK
);

