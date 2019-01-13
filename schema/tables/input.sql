/**
 * Input/SDR Table
 */
CREATE TABLE htm.input (
  id              TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW() PRIMARY KEY,
  columns_active  INTEGER[],  -- NULL OK
  created         TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  indexes         INTEGER[] NOT NULL,
  modified        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

