/**
 * Link (Distal) Cell to Synapse Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM link_distal_cell_synapse; $$,
  ROW(0::BIGINT),
  'Link_Distal_Cell_Synapse has valid data (none)'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

