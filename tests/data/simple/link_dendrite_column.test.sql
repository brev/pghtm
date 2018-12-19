/**
 * Link Dendrite to Column Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT row_eq(
  $$ SELECT COUNT(id) FROM link_dendrite_column; $$, 
  ROW(config_int('DataSimpleCountColumn')::bigint), 
  'Link_Dendrite_Column has valid data'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

