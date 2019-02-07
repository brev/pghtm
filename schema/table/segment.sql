/**
 * Segment Table
 */
CREATE TABLE htm.segment (
  id      SERIAL PRIMARY KEY,
  class   htm.SEGMENT_CLASS NOT NULL
);

