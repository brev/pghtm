/**
 * Synapse (Distal: Active) Views
 * @TemporalMemory
 */
CREATE VIEW htm.synapse_distal_active AS (
  SELECT synapse.id
  FROM htm.synapse
  JOIN htm.synapse_distal_connect
    ON synapse_distal_connect.id = synapse.id
  JOIN htm.segment
    ON segment.id = synapse.segment_id
    AND segment.class = 'distal'
  JOIN htm.link_distal_cell_synapse
    ON link_distal_cell_synapse.synapse_id = synapse.id
  JOIN htm.cell
    ON cell.id = link_distal_cell_synapse.cell_id
    AND cell.active
);

