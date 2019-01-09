/**
 * Column View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test column_overlap
SELECT has_view('column_overlap');
SELECT has_column('column_overlap', 'id');
SELECT has_column('column_overlap', 'overlap');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

