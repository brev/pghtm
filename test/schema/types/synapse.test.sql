/**
 * Synapse Types Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(1);  -- Test count


SELECT has_type('synapse_connection');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

