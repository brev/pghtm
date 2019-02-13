/**
 * Segment (Distal: Active) View
 * @TemporalMemory
 */
CREATE VIEW htm.segment_active AS (
  SELECT s.id
  FROM htm.segment AS s
  JOIN htm.synapse_distal AS sd
    ON sd.segment_id = s.id
  JOIN htm.synapse_distal_active AS sda
    ON sda.id = sd.id
  GROUP BY s.id
  HAVING htm.segment_is_active(
    COUNT(sda.id)::INT
  )
);

