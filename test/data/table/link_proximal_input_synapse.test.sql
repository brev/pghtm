/**
 * Link (Proximal) Input to Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM link_proximal_input_synapse; $$,
  ROW((
    config('column_count')::INT *
    config('synapse_proximal_count')::INT
  )::BIGINT),
  'Link_Proximal_Input_Synapse has valid data'
);

SELECT throws_ok($$
    INSERT INTO link_proximal_input_synapse (input_index, synapse_id)
      VALUES (10, 22), (10, 22);
  $$,
  '23505',
  'duplicate key value violates unique constraint "link_proximal_input_synapse_input_index_synapse_id_key"'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

