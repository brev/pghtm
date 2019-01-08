/**
 * Spatial Pooler Functions Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(21);  -- Test count


-- test sp_compute_iteration_update()
SELECT has_function('sp_compute_iteration_update');
SELECT function_lang_is('sp_compute_iteration_update', 'plpgsql');
SELECT function_returns('sp_compute_iteration_update', 'trigger');

-- test sp_get()
SELECT has_function('sp_get', ARRAY['character varying']);
SELECT function_lang_is('sp_get', 'plpgsql');
SELECT function_returns('sp_get', 'character varying');

-- test sp_set()
SELECT has_function('sp_set', 
  ARRAY['character varying', 'character varying']
);
SELECT function_lang_is('sp_set', 'plpgsql');
SELECT function_returns('sp_set', 'boolean');

-- test sp_column_active()
SELECT has_function('sp_column_active', ARRAY['integer[]']);
SELECT function_lang_is('sp_column_active', 'plpgsql');
SELECT function_returns('sp_column_active', 'integer[]');

-- test sp_column_overlap()
SELECT has_function('sp_column_overlap', ARRAY['integer[]']);
SELECT function_lang_is('sp_column_overlap', 'plpgsql');
SELECT function_returns('sp_column_overlap', 'boolean');

-- test sp_synapse_learn()
SELECT has_function('sp_synapse_learn', ARRAY['integer[]']);
SELECT function_lang_is('sp_synapse_learn', 'plpgsql');
SELECT function_returns('sp_synapse_learn', 'boolean');

-- test sp_compute()
SELECT has_function('sp_compute', ARRAY['integer[]']);
SELECT function_lang_is('sp_compute', 'plpgsql');
SELECT function_returns('sp_compute', 'integer[]');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

