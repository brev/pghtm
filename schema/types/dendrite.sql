/**
 * Dendrite Types
 */

/**
 * Dendrite Class Type
 */
CREATE TYPE htm.DENDRITE_CLASS AS ENUM (
  'apical',   -- feedback
  'distal',   -- context
  'proximal'  -- feedforward
);

