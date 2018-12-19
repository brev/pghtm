/**
 * Input Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(10);  -- Test count


SELECT has_table('input');
SELECT columns_are('input', ARRAY['id', 'length', 'indexes']);
SELECT has_pk('input');

SELECT col_type_is('input', 'id', 'integer');
SELECT col_not_null('input', 'id');
SELECT col_is_pk('input', 'id');

SELECT col_type_is('input', 'length', 'integer');
SELECT col_not_null('input', 'length');

SELECT col_type_is('input', 'indexes', 'integer[]');
SELECT col_not_null('input', 'indexes');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

