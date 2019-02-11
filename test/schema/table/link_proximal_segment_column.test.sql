/**
 * Link Segment to Column Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(21);  -- Test count


SELECT has_table('link_proximal_segment_column');
SELECT columns_are('link_proximal_segment_column', ARRAY[
  'id',
  'column_id',
  'created',
  'segment_id'
]);
SELECT has_pk('link_proximal_segment_column');
SELECT has_fk('link_proximal_segment_column');
SELECT has_unique('link_proximal_segment_column');
SELECT has_check('link_proximal_segment_column');

SELECT col_type_is('link_proximal_segment_column', 'id', 'integer');
SELECT col_not_null('link_proximal_segment_column', 'id');
SELECT col_is_pk('link_proximal_segment_column', 'id');
SELECT col_has_check('link_proximal_segment_column', 'id');

SELECT col_type_is('link_proximal_segment_column', 'column_id', 'integer');
SELECT col_not_null('link_proximal_segment_column', 'column_id');
SELECT col_is_fk('link_proximal_segment_column', 'column_id');

SELECT col_type_is(
  'link_proximal_segment_column',
  'created',
  'timestamp with time zone'
);
SELECT col_not_null('link_proximal_segment_column', 'created');
SELECT col_has_default('link_proximal_segment_column', 'created');
SELECT col_default_is('link_proximal_segment_column', 'created', 'now()');

SELECT col_type_is('link_proximal_segment_column', 'segment_id', 'integer');
SELECT col_not_null('link_proximal_segment_column', 'segment_id');
SELECT col_is_fk('link_proximal_segment_column', 'segment_id');

SELECT col_is_unique('link_proximal_segment_column', ARRAY[
  'segment_id',
  'column_id'
]);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

