/**
 * Column (Overlap/Boosting) View Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(4);  -- Test count


-- test column_overlap_boost
SELECT has_view('column_overlap_boost');
SELECT has_column('column_overlap_boost', 'id');
SELECT has_column('column_overlap_boost', 'overlap');
SELECT has_column('column_overlap_boost', 'overlap_boosted');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

