/**
 * Segment Schema Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(10);  -- Test count


SELECT has_table('segment');
SELECT columns_are('segment', ARRAY[
  'id',
  'class',
  'created'
]);
SELECT has_pk('segment');
SELECT has_check('segment');

SELECT col_type_is('segment', 'id', 'integer');
SELECT col_not_null('segment', 'id');
SELECT col_is_pk('segment', 'id');
SELECT col_has_check('segment', 'id');

SELECT col_type_is('segment', 'class', 'segment_class');
SELECT col_not_null('segment', 'class');


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

