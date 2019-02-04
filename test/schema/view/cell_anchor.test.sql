/**
 * Cell (Bursting "Learner" Anchor) View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(4);  -- Test count


-- test cell_anchor
SELECT has_view('cell_anchor');
SELECT has_column('cell_anchor', 'id');
SELECT has_column('cell_anchor', 'column_id');
SELECT has_column('cell_anchor', 'segment_grow');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

