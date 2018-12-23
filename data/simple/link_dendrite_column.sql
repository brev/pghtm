/**
 * Link: Dendrite to Column Data
 */

DO
$$
DECLARE
  CountColumn INT := htm.config_int('DataSimpleCountColumn');
  CountDendrite INT := htm.config_int('DataSimpleCountDendrite');
  CountNeuron INT := htm.config_int('DataSimpleCountNeuron');
  lastDendriteId INT := CountNeuron * CountDendrite;
BEGIN
  FOR columnId IN 1..CountColumn LOOP
    INSERT
      INTO htm.link_dendrite_column (id, dendrite_id, column_id)
      VALUES (columnId, lastDendriteId + columnId, columnId);
  END LOOP;
END
$$;

