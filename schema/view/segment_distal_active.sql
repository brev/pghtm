/**
 * Segment (Distal: Active) View
 * @TemporalMemory
 */
CREATE VIEW htm.segment_distal_active AS (
  SELECT segment.id
  FROM htm.segment
  JOIN htm.synapse
    ON synapse.segment_id = segment.id
  JOIN htm.synapse_distal_active
    ON synapse_distal_active.id = synapse.id
  WHERE segment.class = 'distal'
  GROUP BY segment.id
  HAVING htm.segment_is_active(
    COUNT(synapse_distal_active.id)::INT
  )
);

