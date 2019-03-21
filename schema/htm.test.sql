/**
 * HTM Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT has_schema('htm');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

