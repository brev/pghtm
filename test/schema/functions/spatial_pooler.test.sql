/**
 * Spatial Pooler Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(18);  -- Test count


SELECT has_function('sp_get', ARRAY['character varying']);
SELECT function_lang_is('sp_get', 'plpgsql');
SELECT function_returns('sp_get', 'character varying');

SELECT has_function('sp_set', 
  ARRAY['character varying', 'character varying']
);
SELECT function_lang_is('sp_set', 'plpgsql');
SELECT function_returns('sp_set', 'boolean');

SELECT has_function('sp_column_active', ARRAY['integer[]']);
SELECT function_lang_is('sp_column_active', 'plpgsql');
SELECT function_returns('sp_column_active', 'integer[]');

SELECT has_function('sp_column_overlap', ARRAY['integer[]']);
SELECT function_lang_is('sp_column_overlap', 'plpgsql');
SELECT function_returns('sp_column_overlap', 'boolean');

SELECT has_function('sp_synapse_learn', ARRAY['integer[]']);
SELECT function_lang_is('sp_synapse_learn', 'plpgsql');
SELECT function_returns('sp_synapse_learn', 'boolean');

SELECT has_function('sp_compute', ARRAY['integer[]']);
SELECT function_lang_is('sp_compute', 'plpgsql');
SELECT function_returns('sp_compute', 'integer[]');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

