/**
 * Link Segment to Column Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(13);  -- Test count


SELECT has_table('link_proximal_segment_column');
SELECT columns_are(
  'link_proximal_segment_column',
  ARRAY['id', 'segment_id', 'column_id']
);
SELECT has_pk('link_proximal_segment_column');
SELECT has_fk('link_proximal_segment_column');

SELECT col_type_is('link_proximal_segment_column', 'id', 'integer');
SELECT col_not_null('link_proximal_segment_column', 'id');
SELECT col_is_pk('link_proximal_segment_column', 'id');

SELECT col_type_is('link_proximal_segment_column', 'segment_id', 'integer');
SELECT col_not_null('link_proximal_segment_column', 'segment_id');
SELECT col_is_fk('link_proximal_segment_column', 'segment_id');

SELECT col_type_is('link_proximal_segment_column', 'column_id', 'integer');
SELECT col_not_null('link_proximal_segment_column', 'column_id');
SELECT col_is_fk('link_proximal_segment_column', 'column_id');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

