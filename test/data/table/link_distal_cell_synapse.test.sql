/**
 * Link Cell to Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM link_distal_cell_synapse; $$,
  ROW((
    config('cell_count')::INT *
    config('segment_count')::INT *
    config('synapse_count')::INT
  )::BIGINT),
  'Link_Cell_Synapse has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

