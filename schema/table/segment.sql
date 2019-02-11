/**
 * Segment Table
 */
CREATE TABLE htm.segment (
  id      SERIAL PRIMARY KEY,
  class   htm.SEGMENT_CLASS NOT NULL,
  created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

  CHECK (id > 0)
);

