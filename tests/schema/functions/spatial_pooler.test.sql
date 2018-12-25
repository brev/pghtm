/**
 * Spatial Pooler Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(9);  -- Test count


SELECT has_function('spatial_pooler_get');
SELECT function_lang_is('spatial_pooler_get', 'plpgsql');
SELECT function_returns('spatial_pooler_get', 'character varying');

SELECT has_function('spatial_pooler_set');
SELECT function_lang_is('spatial_pooler_set', 'plpgsql');
SELECT function_returns('spatial_pooler_set', 'boolean');

SELECT has_function('spatial_pooler_compute');
SELECT function_lang_is('spatial_pooler_compute', 'plpgsql');
SELECT function_returns('spatial_pooler_compute', 'boolean');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

