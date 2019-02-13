/**
 * Synapse (Distal: Connected) View
 * @TemporalMemory
 */
CREATE VIEW htm.synapse_distal_connect AS (
  SELECT sd.id
  FROM htm.synapse_distal AS sd
  JOIN htm.segment AS s
    ON s.id = sd.segment_id
  WHERE htm.synapse_distal_get_connection(sd.permanence)
);

