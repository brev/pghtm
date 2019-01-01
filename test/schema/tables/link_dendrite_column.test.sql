/**
 * Link Dendrite to Column Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(13);  -- Test count


SELECT has_table('link_dendrite_column');
SELECT columns_are('link_dendrite_column', ARRAY['id', 'dendrite_id', 'column_id']);
SELECT has_pk('link_dendrite_column');
SELECT has_fk('link_dendrite_column');

SELECT col_type_is('link_dendrite_column', 'id', 'integer');
SELECT col_not_null('link_dendrite_column', 'id');
SELECT col_is_pk('link_dendrite_column', 'id');

SELECT col_type_is('link_dendrite_column', 'dendrite_id', 'integer');
SELECT col_not_null('link_dendrite_column', 'dendrite_id');
SELECT col_is_fk('link_dendrite_column', 'dendrite_id');

SELECT col_type_is('link_dendrite_column', 'column_id', 'integer');
SELECT col_not_null('link_dendrite_column', 'column_id');
SELECT col_is_fk('link_dendrite_column', 'column_id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

