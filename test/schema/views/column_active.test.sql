/**
 * Column (Active) View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(2);  -- Test count


-- test column_active
SELECT has_view('column_active');
SELECT has_column('column_active', 'id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

