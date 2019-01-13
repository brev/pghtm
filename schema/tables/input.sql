/**
 * Input/SDR Table
 */
CREATE TABLE htm.input (
  id        SERIAL PRIMARY KEY,
  created   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  modified  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
 
  -- input data 
  ts        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  indexes   INTEGER[] NOT NULL,

  -- sp output
  columns_active INTEGER[]  -- NULL OK
);

