/**
 * Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(7);  -- Test count


-- test synapse counts
SELECT row_eq(
  $$
    SELECT COUNT(synapse.id)
    FROM synapse
    JOIN segment
      ON segment.id = synapse.segment_id
      AND segment.class = 'distal';
  $$,
  ROW((
    config('cell_count')::INT *
    config('segment_count')::INT *
    config('synapse_count')::INT
  )::BIGINT),
  'Synapse (Distal) has valid count total'
);
SELECT row_eq(
  $$
    SELECT COUNT(synapse.id)
    FROM synapse
    JOIN segment
      ON segment.id = synapse.segment_id
      AND segment.class = 'proximal';
  $$,
  ROW((
    config('column_count')::INT *
    config('synapse_count')::INT
  )::BIGINT),
  'Synapse (Proximal) has valid count total'
);
SELECT row_eq(
  $$ SELECT COUNT(synapse.id) FROM synapse; $$,
  ROW((
    (
      config('cell_count')::INT *
      config('segment_count')::INT *
      config('synapse_count')::INT
    ) + (
      config('column_count')::INT *
      config('synapse_count')::INT
    )
  )::BIGINT),
  'Synapse (All) has valid count total'
);

-- test synapse permanence init
SELECT row_eq(
  $$
    SELECT (COUNT(synapse.id) > 0)
    FROM synapse
    JOIN segment
      ON segment.id = synapse.segment_id
      AND segment.class = 'distal'
    WHERE (
      permanence < (
        config('synapse_distal_threshold')::NUMERIC -
        config('synapse_distal_decrement')::NUMERIC
      )
      OR permanence > (
        config('synapse_distal_threshold')::NUMERIC +
        config('synapse_distal_increment')::NUMERIC
      )
    )
  $$,
  ROW(FALSE),
  'Synapse (Distal) permanences init in small range around threshold'
);
SELECT row_eq(
  $$
    SELECT (COUNT(synapse.id) > 0)
    FROM synapse
    JOIN segment
      ON segment.id = synapse.segment_id
      AND segment.class = 'proximal'
    WHERE (
      permanence < (
        config('synapse_proximal_threshold')::NUMERIC -
        config('synapse_proximal_decrement')::NUMERIC
      )
      OR permanence > (
        config('synapse_proximal_threshold')::NUMERIC +
        config('synapse_proximal_increment')::NUMERIC
      )
    )
  $$,
  ROW(FALSE),
  'Synapse (Proximal) permanences init in small range around threshold'
);

-- test synapse permanence changes
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3,4]);
SELECT row_eq(
  $$
    SELECT (COUNT(synapse.id) > 0)
    FROM synapse
    JOIN segment
      ON segment.id = synapse.segment_id
      AND segment.class = 'distal'
    WHERE (
      permanence < (
        config('synapse_distal_threshold')::NUMERIC -
        config('synapse_distal_decrement')::NUMERIC
      )
      OR permanence > (
        config('synapse_distal_threshold')::NUMERIC +
        config('synapse_distal_increment')::NUMERIC
      )
    )
  $$,
  ROW(TRUE),
  'Synapse (Distal) permanences learn away from threshold range'
);
SELECT row_eq(
  $$
    SELECT (COUNT(synapse.id) > 0)
    FROM synapse
    JOIN segment
      ON segment.id = synapse.segment_id
      AND segment.class = 'proximal'
    WHERE (
      permanence < (
        config('synapse_proximal_threshold')::NUMERIC -
        config('synapse_proximal_decrement')::NUMERIC
      )
      OR permanence > (
        config('synapse_proximal_threshold')::NUMERIC +
        config('synapse_proximal_increment')::NUMERIC
      )
    )
  $$,
  ROW(TRUE),
  'Synapse (Proximal) permanences learn away from threshold range'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

