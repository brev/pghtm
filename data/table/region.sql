/**
 * Region Data
 */
DO
$$
BEGIN
  RAISE NOTICE 'Inserting 1 Region...';

  INSERT INTO htm.region DEFAULT VALUES;
END
$$;

