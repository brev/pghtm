/**
 * Input/SDR Data
 */

DO
$$
DECLARE
  WidthInput INT := htm.config('WidthInput');
BEGIN
  INSERT 
    INTO htm.input (id, indexes) 
    VALUES (NOW(), ARRAY[0, 1, 2]);
END
$$;

