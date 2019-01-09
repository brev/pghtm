/**
 * Column View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test column_proximal_overlap
SELECT has_view('column_proximal_overlap');
SELECT has_column('column_proximal_overlap', 'id');
SELECT has_column('column_proximal_overlap', 'overlap');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

