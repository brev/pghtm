/**
 * Synapse (Distal) Data Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test distal synapse counts
SELECT row_eq(
  $$
    SELECT (COUNT(sd.id) > 0)
    FROM synapse_distal AS sd
  $$,
  ROW(FALSE),
  'Synapse (Distal) has valid startup count total (none)'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
SELECT row_eq(
  $$
    SELECT (COUNT(sd.id) > 0)
    FROM synapse_distal AS sd
    WHERE sd.permanence > (
      config('synapse_distal_threshold')::NUMERIC +
      config('synapse_distal_increment')::NUMERIC
    )
  $$,
  ROW(FALSE),
  'Synapse (Distal) permanences init correctly'
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
    SELECT (COUNT(sd.id) > 0)
    FROM synapse_distal AS sd
    WHERE (
      sd.permanence <= config('synapse_distal_threshold')::NUMERIC
      OR
      sd.permanence > (
        config('synapse_distal_threshold')::NUMERIC +
        config('synapse_distal_increment')::NUMERIC
      )
    )
  $$,
  ROW(TRUE),
  'Synapse (Distal) permanences learn away from threshold range'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

