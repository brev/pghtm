/**
 * Segment Distal "Learner" Anchor View
 *  Used to help choose Learning Anchor Cells, and to figure which segments
 *  to grow new synapses on. Best matching segments to learn on.
 * @TemporalMemory
 */
CREATE VIEW htm.segment_distal_anchor AS (
  SELECT
    s.id,
    COUNT(sd.id) AS synapse_count,
    ROW_NUMBER() OVER (
      PARTITION BY s.cell_id
      ORDER BY
        COUNT(sd.id) DESC,
        RANDOM() DESC
    ) AS order_id
  FROM htm.segment AS s
  JOIN htm.synapse_distal AS sd
    ON sd.segment_id = s.id
  JOIN htm.cell AS c
    ON c.id = sd.input_cell_id
    AND c.active_last
  GROUP BY
    s.cell_id,
    s.id
  HAVING COUNT(sd.id) < htm.config('synapse_distal_count')::INT
  ORDER BY
    s.cell_id,
    COUNT(sd.id) DESC,
    RANDOM() DESC
);

