/**
 * Region Data
 */
DO
$$
BEGIN
  RAISE NOTICE 'Inserting 1 Region...';

  INSERT INTO htm.region (
    id,
    duty_cycle_active_mean,
    duty_cycle_overlap_mean
  )
  VALUES (
    1,
    0.0,
    0.0
  );
END
$$;

