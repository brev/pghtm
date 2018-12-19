/**
 * Input SDR
 */

DO
$$
DECLARE
  WidthInput INT := htm.config_int('DataSimpleWidthInput');
BEGIN
  INSERT 
    INTO htm.input (id, length, indexes) 
    VALUES (1, WidthInput, ARRAY[0, 1, 2]);
END
$$;

