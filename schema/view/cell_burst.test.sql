/**
 * Cell (Proximal: Bursting) View Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test cell_burst
SELECT has_view('cell_burst');
SELECT has_column('cell_burst', 'id');
SELECT has_column('cell_burst', 'column_id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

