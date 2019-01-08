/**
 * Synapse Types
 */

/**
 * Synapse State Type
 */
CREATE TYPE htm.SYNAPSE_CONNECTION AS ENUM (
  'connected',
  'potential',
  'unconnected'
);

