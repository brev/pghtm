/**
 * Dendrite (Distal: Active) View
 * @TemporalMemory
 */
CREATE VIEW htm.dendrite_distal_active AS (
  SELECT dendrite.id
  FROM htm.dendrite
  JOIN htm.synapse
    ON synapse.dendrite_id = dendrite.id
  JOIN htm.synapse_distal_active
    ON synapse_distal_active.id = synapse.id
  WHERE dendrite.class = 'distal'
  GROUP BY dendrite.id
  HAVING htm.dendrite_is_active(
    COUNT(synapse_distal_active.id)::INT
  )
);

