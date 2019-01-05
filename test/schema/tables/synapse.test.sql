/**
 * Synapse Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(19);  -- Test count


SELECT has_table('synapse');
SELECT columns_are(
  'synapse', 
  ARRAY['id', 'dendrite_id', 'permanence', 'state']
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
SELECT col_has_default('synapse', 'permanence');
SELECT col_default_is('synapse', 'permanence', 0.0);

SELECT col_type_is('synapse', 'state', 'synapse_state');
SELECT col_not_null('synapse', 'state');
SELECT col_has_default('synapse', 'state');
SELECT col_default_is('synapse', 'state', 'unconnected');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

