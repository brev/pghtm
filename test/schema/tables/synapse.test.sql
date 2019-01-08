/**
 * Synapse Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(17);  -- Test count


SELECT has_table('synapse');
SELECT columns_are(
  'synapse', 
  ARRAY['id', 'dendrite_id', 'permanence', 'connected', 'active']
);
SELECT has_pk('synapse');
SELECT has_fk('synapse');

SELECT col_type_is('synapse', 'id', 'integer');
SELECT col_not_null('synapse', 'id');
SELECT col_is_pk('synapse', 'id');

SELECT col_type_is('synapse', 'dendrite_id', 'integer');
SELECT col_not_null('synapse', 'dendrite_id');
SELECT col_is_fk('synapse', 'dendrite_id');

SELECT col_type_is('synapse', 'permanence', 'numeric');
SELECT col_not_null('synapse', 'permanence');
SELECT col_has_check('synapse', 'permanence');

SELECT col_type_is('synapse', 'connected', 'boolean');
SELECT col_not_null('synapse', 'connected');

SELECT col_type_is('synapse', 'active', 'boolean');
SELECT col_not_null('synapse', 'active');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

