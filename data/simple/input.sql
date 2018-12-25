/**
 * Input/SDR Data
 */

DO
$$
DECLARE
  WidthInput INT := htm.config('WidthInput');
BEGIN
  INSERT 
    INTO htm.input (id, length, indexes) 
    VALUES (1, WidthInput, ARRAY[0, 1, 2]);
END
$$;

