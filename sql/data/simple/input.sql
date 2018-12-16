/**
 * Input SDR
 */

DO
$$
DECLARE
  WidthInput INT := htm.configInt('DataSimpleWidthInput');
BEGIN
  INSERT 
    INTO htm.input (id, length, indexes) 
    VALUES (1, WidthInput, '{0, 1, 2}');
END
$$;

