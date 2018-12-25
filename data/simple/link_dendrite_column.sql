/**
 * Link: Dendrite to Column Data
 */

DO
$$
DECLARE
  CountColumn INT := htm.config('CountColumn');
  CountDendrite INT := htm.config('CountDendrite');
  CountNeuron INT := htm.config('CountNeuron');
  lastDendriteId INT := CountNeuron * CountDendrite;
BEGIN
  FOR columnId IN 1..CountColumn LOOP
    INSERT
      INTO htm.link_dendrite_column (id, dendrite_id, column_id)
      VALUES (columnId, lastDendriteId + columnId, columnId);
  END LOOP;
END
$$;

