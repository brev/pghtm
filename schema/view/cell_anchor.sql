/**
 * Cell "Learner" Anchor View
 * @TemporalMemory
 */
CREATE VIEW htm.cell_anchor AS (
  SELECT
    l.id,
    l.column_id,
    l.segment_grow
  FROM (
    (
      -- bursting cells from SP proximal feed-forward input
      SELECT
        cb.id,
        cb.column_id,
        (COUNT(c.id) = 0) AS segment_grow,
        ROW_NUMBER() OVER (
          PARTITION BY cb.column_id
          ORDER BY
            COUNT(c.id) DESC,
            COUNT(DISTINCT(ldsc.segment_id)) ASC,
            RANDOM() DESC
        ) AS order_id
      FROM htm.cell_burst AS cb
      LEFT JOIN htm.cell_predict AS cp
        ON cp.id = cb.id
      LEFT JOIN htm.link_distal_segment_cell AS ldsc
        ON ldsc.cell_id = cb.id
      LEFT JOIN htm.synapse AS s
        ON s.segment_id = ldsc.segment_id
      LEFT JOIN htm.link_distal_cell_synapse AS ldcs
        ON ldcs.synapse_id = s.id
      LEFT JOIN htm.cell AS c
        ON c.id = ldcs.cell_id
        AND c.active_last
      WHERE cp.id IS NULL
      GROUP BY cb.id, cb.column_id
    ) UNION (
      -- predictive cells from TM distal feedback
      SELECT
        cp.id,
        cp.column_id,
        FALSE AS segment_grow,
        1 AS order_id
      FROM htm.cell_predict AS cp
      JOIN htm.column AS col
        ON col.id = cp.column_id
        AND col.active
    )
  ) AS l
  WHERE l.order_id = 1  -- one winner anchor learning cell per bursting column
);

