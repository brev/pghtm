/**
 * Link Segment to Cell Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(15);  -- Test count


SELECT has_table('link_distal_segment_cell');
SELECT columns_are(
  'link_distal_segment_cell',
  ARRAY['id', 'segment_id', 'cell_id']
);
SELECT has_pk('link_distal_segment_cell');
SELECT has_fk('link_distal_segment_cell');
SELECT has_unique('link_distal_segment_cell');

SELECT col_type_is('link_distal_segment_cell', 'id', 'integer');
SELECT col_not_null('link_distal_segment_cell', 'id');
SELECT col_is_pk('link_distal_segment_cell', 'id');

SELECT col_type_is('link_distal_segment_cell', 'segment_id', 'integer');
SELECT col_not_null('link_distal_segment_cell', 'segment_id');
SELECT col_is_fk('link_distal_segment_cell', 'segment_id');

SELECT col_type_is('link_distal_segment_cell', 'cell_id', 'integer');
SELECT col_not_null('link_distal_segment_cell', 'cell_id');
SELECT col_is_fk('link_distal_segment_cell', 'cell_id');

SELECT col_is_unique('link_distal_segment_cell', ARRAY[
  'segment_id',
  'cell_id'
]);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

