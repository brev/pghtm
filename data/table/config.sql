/**
 * Config Data
 */
DO
$$
BEGIN
  RAISE NOTICE 'Inserting Config Data...';

  INSERT INTO htm.config DEFAULT VALUES;
END
$$;

