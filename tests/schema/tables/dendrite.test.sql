/**
 * Dendrite Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(6);  -- Test count


SELECT has_table('dendrite');
SELECT columns_are('dendrite', ARRAY['id']);
SELECT has_pk('dendrite');

SELECT col_type_is('dendrite', 'id', 'integer');
SELECT col_not_null('dendrite', 'id');
SELECT col_is_pk('dendrite', 'id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

