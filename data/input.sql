/**
 * Input/SDR Data
 */

DO
$$
DECLARE
  InputWidth INT := htm.config('InputWidth');
BEGIN
  INSERT 
    INTO htm.input (id, indexes) 
    VALUES (NOW(), ARRAY[0, 1, 2]);
END
$$;

