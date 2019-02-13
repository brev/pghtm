/**
 * Synapse (Proximal: Connected) View
 * @SpatialPooler
 */
CREATE VIEW htm.synapse_proximal_connect AS (
  SELECT sp.id
  FROM htm.synapse_proximal AS sp
  WHERE htm.synapse_proximal_get_connection(sp.permanence)
);

