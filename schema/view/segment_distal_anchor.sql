/**
 * Segment Distal "Learner" Anchor View
 *  Used to help choose Learning Anchor Cells, and to figure which segments
 *  to grow new synapses on. Best matching segments to learn on.
 * @TemporalMemory
 */
CREATE VIEW htm.segment_distal_anchor AS (
  SELECT
    ldsc.segment_id AS id,
    COUNT(s.id) AS synapse_count,
    ROW_NUMBER() OVER (
      PARTITION BY ldsc.cell_id
      ORDER BY
        COUNT(s.id) DESC,
        RANDOM() DESC
    ) AS order_id
  FROM htm.link_distal_segment_cell AS ldsc
  JOIN htm.synapse AS s
    ON s.segment_id = ldsc.segment_id
  JOIN htm.link_distal_cell_synapse AS ldcs
    ON ldcs.synapse_id = s.id
  JOIN htm.cell AS c
    ON c.id = ldcs.cell_id
    AND c.active_last
  GROUP BY
    ldsc.cell_id,
    ldsc.segment_id
  HAVING COUNT(s.id) < htm.config('synapse_distal_count')::INT
  ORDER BY
    ldsc.cell_id,
    COUNT(s.id) DESC,
    RANDOM() DESC
);

