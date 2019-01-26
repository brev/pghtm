/**
 * Dendrite Class Type
 */
CREATE TYPE htm.DENDRITE_CLASS AS ENUM (
  'apical',   -- feedback/hierarchy TODO
  'distal',   -- context/time
  'proximal'  -- feedforward/space
);

