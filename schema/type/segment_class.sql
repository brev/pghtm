/**
 * Segment Class Type
 */
CREATE TYPE htm.SEGMENT_CLASS AS ENUM (
  'apical',   -- feedback/hierarchy TODO
  'distal',   -- context/time
  'proximal'  -- feedforward/space
);

