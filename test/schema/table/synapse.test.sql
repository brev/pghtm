/**
 * Synapse Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(14);  -- Test count


SELECT has_table('synapse');
SELECT columns_are('synapse', ARRAY['id', 'segment_id', 'permanence']);
SELECT has_pk('synapse');
SELECT has_fk('synapse');
SELECT has_check('synapse');

SELECT col_type_is('synapse', 'id', 'integer');
SELECT col_not_null('synapse', 'id');
SELECT col_is_pk('synapse', 'id');

SELECT col_type_is('synapse', 'segment_id', 'integer');
SELECT col_not_null('synapse', 'segment_id');
SELECT col_is_fk('synapse', 'segment_id');

SELECT col_type_is('synapse', 'permanence', 'numeric');
SELECT col_not_null('synapse', 'permanence');
SELECT col_has_check('synapse', 'permanence');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

