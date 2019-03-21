/**
 * Config Function Schema Tests
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(5);  -- Test count


-- test config()
SELECT has_function('config', ARRAY['text']);
SELECT function_lang_is('config', 'plpgsql');
SELECT function_returns('config', 'text');

-- test config_generate()
SELECT has_function('config_generate');
SELECT function_lang_is('config_generate', 'plpgsql');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

