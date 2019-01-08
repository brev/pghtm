/**
 * Dendrite Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(10);  -- Test count


SELECT has_table('dendrite');
SELECT columns_are('dendrite', ARRAY['id', 'class', 'active']);
SELECT has_pk('dendrite');

SELECT col_type_is('dendrite', 'id', 'integer');
SELECT col_not_null('dendrite', 'id');
SELECT col_is_pk('dendrite', 'id');

SELECT col_type_is('dendrite', 'class', 'dendrite_class');
SELECT col_not_null('dendrite', 'class');

SELECT col_type_is('synapse', 'active', 'boolean');
SELECT col_not_null('synapse', 'active');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

