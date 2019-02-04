/**
 * Cell (Bursting "Learner" Anchor) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test cell_anchor
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM cell_anchor $$,
  ROW(FALSE),
  'Cell Burst Anchor view has valid init count'
);
INSERT INTO input (indexes) VALUES (ARRAY[0,1,2,3]);
/* -- need these cells to link > segment > synapse > cell.active_last
SELECT row_eq(
  $$ SELECT (COUNT(id) > 0) FROM cell_anchor $$,
  ROW(TRUE),
  'Cell Burst Anchor view has valid count after data'
);
*/
SELECT is(1,1,'TODO');

SELECT * FROM finish();
ROLLBACK;  -- Don't save test data
