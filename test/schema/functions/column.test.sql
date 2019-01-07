/**
 * Column Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(3);  -- Test count


-- test column_overlap_update()
SELECT has_function('column_overlap_update');
SELECT function_lang_is('column_overlap_update', 'plpgsql');
SELECT function_returns('column_overlap_update', 'trigger');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

