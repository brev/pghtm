/**
 * Synapse (Distal: Active) View
 * @TemporalMemory
 */
CREATE VIEW htm.synapse_distal_active AS (
  SELECT sd.id
  FROM htm.synapse_distal AS sd
  JOIN htm.synapse_distal_connect AS sdc
    ON sdc.id = sd.id
  JOIN htm.cell AS c
    ON c.id = sd.input_cell_id
    AND c.active
);

