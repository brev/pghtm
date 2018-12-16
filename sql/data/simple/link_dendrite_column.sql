/**
 * Link: Dendrite to Column
 */

DO
$$
DECLARE
  CountColumn INT := htm.configInt('DataSimpleCountColumn');
  CountDendrite INT := htm.configInt('DataSimpleCountDendrite');
  CountNeuron INT := htm.configInt('DataSimpleCountNeuron');
  lastDendriteId INT := CountNeuron * CountDendrite;
BEGIN
  FOR columnId IN 1..CountColumn LOOP
    INSERT
      INTO htm.link_dendrite_column (id, dendrite_id, column_id)
      VALUES (columnId, lastDendriteId + columnId, columnId);
  END LOOP;
END
$$;

