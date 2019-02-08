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
  ROW(0::BIGINT),
  'Synapse (Distal) has valid startup count total (none)'
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
    config('synapse_proximal_count')::INT
  )::BIGINT),
  'Synapse (Proximal) has valid count total'
);

-- test proximal synapse permanence init values step 0
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
-- test distal synapse permanence init values step 1
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
SELECT row_eq(
  $$
    SELECT (COUNT(synapse.id) > 0)
    FROM synapse
    JOIN segment
      ON segment.id = synapse.segment_id
      AND segment.class = 'distal'
    WHERE permanence > (
      config('synapse_distal_threshold')::NUMERIC +
      config('synapse_distal_increment')::NUMERIC
    )
  $$,
  ROW(FALSE),
  'Synapse (Distal) permanences init correctly'
);
-- test proximal synapse permanence changes on step 1
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
-- test distal synapse permanence changes on step 2
INSERT INTO input (indexes) VALUES (ARRAY[10,11,12,13]);
INSERT INTO input (indexes) VALUES (ARRAY[20,21,22,23]);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
INSERT INTO input (indexes) VALUES (ARRAY[10,11,12,13]);
INSERT INTO input (indexes) VALUES (ARRAY[20,21,22,23]);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
SELECT row_eq(
  $$
    SELECT (COUNT(synapse.id) > 0)
    FROM synapse
    JOIN segment
      ON segment.id = synapse.segment_id
      AND segment.class = 'distal'
    WHERE (
      permanence <= config('synapse_distal_threshold')::NUMERIC
      OR permanence > (
        config('synapse_distal_threshold')::NUMERIC +
        config('synapse_distal_increment')::NUMERIC
      )
    )
  $$,
  ROW(TRUE),
  'Synapse (Distal) permanences learn away from threshold range'
);

-- test trigger_trigger_link_distal_cell_synapse_segment_unique_change
---- function synapse_distal_segment_unique_update()
---- this needs to be after enough input rows have been fed to TM
WITH
  link_new AS (
    SELECT
      (SELECT MAX(id) FROM cell) AS cell_id,
      (SELECT MAX(id) FROM synapse) AS synapse_id
  )
  INSERT INTO link_distal_cell_synapse (cell_id, synapse_id)
  SELECT cell_id, synapse_id
  FROM link_new;
SELECT row_eq(
  $$
    WITH link_test AS (
      WITH link_new AS (
        SELECT
          (SELECT MAX(id) FROM cell) AS cell_id,
          (SELECT MAX(id) FROM synapse) AS synapse_id
      )
      INSERT INTO link_distal_cell_synapse (cell_id, synapse_id)
      SELECT cell_id, synapse_id
      FROM link_new
      RETURNING id
    )
    SELECT (COUNT(id) > 0)
    FROM link_test
  $$,
  ROW(FALSE),
  'Synapse (Distal) unique link per segment ok'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

