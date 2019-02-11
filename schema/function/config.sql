/**
 * Config Functions
 */


/**
 * Temporary config getter function for data init. This will be overwritten
 *  by htm.config_generate() below, triggered after the htm.config table
 *  is updated.
 */
CREATE FUNCTION htm.config(key_in TEXT)
RETURNS TEXT
AS $$
BEGIN
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/**
 * Dynamically re/create an htm.config() static/immutable config getter
 *  function. Config option data comes from htm.config table. This function
 *  should be triggered upon updates to that table. This way we can get
 *  blazing-fast and up-to-date config options without costly table access.
 * You'll need to ::CAST the result of the getter:
 *    result INT := htm.config('threshold');  -- plpgsql declaration
 *    SELECT htm.config('threshold')::INT;    -- plain SQL
 */
CREATE FUNCTION htm.config_generate()
RETURNS VOID
AS $$
DECLARE
  config_name TEXT;
  config_value TEXT;
  new_rows TEXT[];
  new_sql TEXT;
BEGIN
  FOR config_name IN (
    SELECT c.column_name
    FROM information_schema.columns AS c
    WHERE c.table_schema = 'htm'
      AND c.table_name = 'config'
      AND c.column_name NOT IN ('id', 'created', 'modified')
    ORDER BY c.ordinal_position ASC
  ) LOOP
    EXECUTE
      FORMAT('SELECT %I FROM htm.config LIMIT 1', config_name)
      INTO config_value;

    -- cast boolean to int
    IF config_value = 'true'
      THEN config_value := '1';
    ELSIF config_value = 'false'
      THEN config_value := '0';
    END IF;

    new_rows := ARRAY_APPEND(
      new_rows,
      FORMAT('(''%s'', %s)', config_name, config_value)
    );
  END LOOP;

  new_sql := FORMAT($sql$
    CREATE OR REPLACE FUNCTION htm.config(key_in TEXT)
    RETURNS TEXT
    AS $config$
    DECLARE
      result NUMERIC;
    BEGIN
      result := (
        SELECT value
        FROM (VALUES %s)
        AS config_tmp (key, value)
        WHERE key = key_in
      );
      RETURN result;
    END;
    $config$ LANGUAGE plpgsql IMMUTABLE;
  $sql$, ARRAY_TO_STRING(new_rows, ','));

  EXECUTE new_sql;
  RETURN;
END;
$$ LANGUAGE plpgsql;

/**
 * Regenerate cached config() getter function after config table data updated.
 */
CREATE FUNCTION htm.config_regenerate_update()
RETURNS TRIGGER
AS $$
BEGIN
  PERFORM htm.debug('Config table updated so regenerating config getter');
  PERFORM htm.config_generate();
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

