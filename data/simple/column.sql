/**
 * Column Data
 */

DO
$$
DECLARE
  CountColumn INT := htm.config('CountColumn');
BEGIN
  FOR columnId IN 1..CountColumn LOOP
    INSERT 
      INTO htm.column (id, region_id, x_coord, activeDutyCycle) 
      VALUES (columnId, 1, columnId, 1.0);
  END LOOP;
END
$$;

