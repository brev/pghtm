/**
 * Spatial Pooler Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(8);  -- Test count


SELECT has_table('spatial_pooler');
SELECT columns_are('spatial_pooler', ARRAY['key', 'value']);
SELECT has_pk('spatial_pooler');

SELECT col_type_is('spatial_pooler', 'key', 'character varying');
SELECT col_not_null('spatial_pooler', 'key');
SELECT col_is_pk('spatial_pooler', 'key');

SELECT col_type_is('spatial_pooler', 'value', 'character varying');
SELECT col_not_null('spatial_pooler', 'value');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

