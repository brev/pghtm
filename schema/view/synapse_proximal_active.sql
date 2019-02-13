/**
 * Synapse (Proximal: Active) Views
 * @SpatialPooler
 */
CREATE VIEW htm.synapse_proximal_active AS (
  SELECT sp.id
  FROM htm.synapse_proximal AS sp
  JOIN htm.synapse_proximal_connect AS spc
    ON spc.id = sp.id
  WHERE ARRAY[sp.input_index] <@ (
    SELECT i.indexes  -- most recent input
    FROM htm.input AS i
    ORDER BY i.id DESC
    LIMIT 1
  )
);

