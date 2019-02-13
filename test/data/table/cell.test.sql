/**
 * Cell Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(6);  -- Test count


-- test cell total count
SELECT row_eq(
  $$
    SELECT COUNT(c.id)
    FROM cell AS c
  $$,
  ROW(config('cell_count')::BIGINT),
  'Cell has valid data'
);

-- test cell trigger NEW.active -> OLD.last_active
SELECT row_eq(
  $$
    SELECT c.active, c.active_last
    FROM cell AS c
    WHERE c.id = 1
  $$,
  ROW(FALSE, FALSE),
  'Cell active states start empty'
);
UPDATE cell SET active = TRUE WHERE id = 1;
SELECT row_eq(
  $$
    SELECT c.active, c.active_last
    FROM cell AS c
    WHERE c.id = 1
  $$,
  ROW(TRUE, FALSE),
  'Cell active state is true, last false'
);
UPDATE cell SET active = TRUE WHERE id = 1;
SELECT row_eq(
  $$
    SELECT c.active, c.active_last
    FROM cell AS c
    WHERE c.id = 1
  $$,
  ROW(TRUE, TRUE),
  'Cell active state is true again, last true'
);
UPDATE cell SET active = FALSE WHERE id = 1;
SELECT row_eq(
  $$
    SELECT c.active, c.active_last
    FROM cell AS c
    WHERE c.id = 1
  $$,
  ROW(FALSE, TRUE),
  'Cell active state is false, last still true'
);
UPDATE cell SET active = FALSE WHERE id = 1;
SELECT row_eq(
  $$
    SELECT c.active, c.active_last
    FROM cell AS c
    WHERE c.id = 1
  $$,
  ROW(FALSE, FALSE),
  'Cell active states ends back with empty'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

