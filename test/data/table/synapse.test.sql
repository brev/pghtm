/**
 * Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(5);  -- Test count


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

-- test synapse permanence init values (proximal only)
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
/*
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
*/
SELECT is(1,1,'TODO');
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

