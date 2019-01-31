/**
 * Cell Types Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT has_type('segment_class');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

