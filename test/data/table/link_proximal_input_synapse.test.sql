/**
 * Link Input to Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM link_proximal_input_synapse; $$,
  ROW((
    config('column_count')::INT *
    config('synapse_count')::INT
  )::BIGINT),
  'Link_Input_Synapse has valid data'
);

SELECT throws_ok('
    INSERT INTO link_proximal_input_synapse VALUES
      (12345, 10, 22),
      (12345, 10, 22);
  ',
  'duplicate key value violates unique constraint "link_proximal_input_synapse_pkey"',
  'Errors on non-unique combo of input_index and synapse_id'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

