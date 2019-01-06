/**
 * Dendrite Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(10);  -- Test count


SELECT has_table('dendrite');
SELECT columns_are('dendrite', ARRAY['id', 'class', 'state']);
SELECT has_pk('dendrite');

SELECT col_type_is('dendrite', 'id', 'integer');
SELECT col_not_null('dendrite', 'id');
SELECT col_is_pk('dendrite', 'id');

SELECT col_type_is('dendrite', 'class', 'dendrite_class');
SELECT col_not_null('dendrite', 'class');

SELECT col_type_is('dendrite', 'state', 'boolean');
SELECT col_not_null('dendrite', 'state');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

