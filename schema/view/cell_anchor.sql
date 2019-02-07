/**
 * Cell "Learning Anchor" View
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
        (SUM(sda.synapse_count) IS NULL) AS segment_grow,
        ROW_NUMBER() OVER (
          PARTITION BY cb.column_id
          ORDER BY
            COALESCE(SUM(sda.synapse_count), 0) DESC,
            COUNT(DISTINCT(ldsc.segment_id)) ASC,
            RANDOM() DESC
        ) AS order_id
      FROM htm.cell_burst AS cb
      LEFT JOIN htm.cell_predict AS cp
        ON cp.id = cb.id
      LEFT JOIN htm.link_distal_segment_cell AS ldsc
        ON ldsc.cell_id = cb.id
      LEFT JOIN htm.segment_distal_anchor AS sda
        ON sda.id = ldsc.segment_id
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

