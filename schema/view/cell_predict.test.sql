/**
 * Cell (Distal: Predict) View Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test cell_predict
SELECT has_view('cell_predict');
SELECT has_column('cell_predict', 'id');
SELECT has_column('cell_predict', 'column_id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

