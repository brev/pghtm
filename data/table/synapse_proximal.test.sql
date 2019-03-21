/**
 * Synapse (Proximal) Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test synapse_proximal counts
SELECT row_eq(
  $$
    SELECT COUNT(sp.id)
    FROM synapse_proximal AS sp
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
    SELECT (COUNT(sp.id) > 0)
    FROM synapse_proximal AS sp
    WHERE (
      sp.permanence < (
        config('synapse_proximal_threshold')::NUMERIC -
        config('synapse_proximal_decrement')::NUMERIC
      )
      OR
      sp.permanence > (
        config('synapse_proximal_threshold')::NUMERIC +
        config('synapse_proximal_increment')::NUMERIC
      )
    )
  $$,
  ROW(FALSE),
  'Synapse (Proximal) permanences init in small range around threshold'
);
-- test proximal synapse permanence changes on step 1
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
SELECT row_eq(
  $$
    SELECT (COUNT(sp.id) > 0)
    FROM synapse_proximal AS sp
    WHERE (
      sp.permanence < (
        config('synapse_proximal_threshold')::NUMERIC -
        config('synapse_proximal_decrement')::NUMERIC
      )
      OR
      sp.permanence > (
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

