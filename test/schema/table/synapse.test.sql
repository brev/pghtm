/**
 * Synapse Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(23);  -- Test count


SELECT has_table('synapse');
SELECT columns_are('synapse', ARRAY[
  'id',
  'created',
  'modified',
  'permanence',
  'segment_id'
]);
SELECT has_pk('synapse');
SELECT has_fk('synapse');
SELECT has_check('synapse');

SELECT col_type_is('synapse', 'id', 'integer');
SELECT col_not_null('synapse', 'id');
SELECT col_is_pk('synapse', 'id');
SELECT col_has_check('synapse', 'id');

SELECT col_type_is('synapse', 'created', 'timestamp with time zone');
SELECT col_not_null('synapse', 'created');
SELECT col_has_default('synapse', 'created');
SELECT col_default_is('synapse', 'created', 'now()');

SELECT col_type_is('synapse', 'modified', 'timestamp with time zone');
SELECT col_not_null('synapse', 'modified');
SELECT col_has_default('synapse', 'modified');
SELECT col_default_is('synapse', 'modified', 'now()');

SELECT col_type_is('synapse', 'permanence', 'numeric');
SELECT col_not_null('synapse', 'permanence');
SELECT col_has_check('synapse', 'permanence');

SELECT col_type_is('synapse', 'segment_id', 'integer');
SELECT col_not_null('synapse', 'segment_id');
SELECT col_is_fk('synapse', 'segment_id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

