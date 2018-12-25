/**
 * Link Input to Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM link_input_synapse; $$, 
  ROW((
    config('CountColumn')::INT *
    config('CountSynapse')::INT
  )::BIGINT), 
  'Link_Input_Synapse has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

