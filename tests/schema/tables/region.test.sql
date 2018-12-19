/**
 * Region Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(6);  -- Test count


SELECT has_table('region');
SELECT columns_are('region', ARRAY['id']);
SELECT has_pk('region');

SELECT col_type_is('region', 'id', 'integer');
SELECT col_not_null('region', 'id');
SELECT col_is_pk('region', 'id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

