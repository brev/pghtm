/**
 * Segment Table
 */

CREATE TABLE htm.segment (
  id      SERIAL PRIMARY KEY,
  class   htm.SEGMENT_CLASS NOT NULL
);

ALTER SEQUENCE htm.segment_id_seq RESTART WITH 1;

