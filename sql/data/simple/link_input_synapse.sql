/**
 * Link: Axon from Input to Synapse
 */

DO
$$
DECLARE
  CountColumn INT := htm.configInt('DataSimpleCountColumn');
  CountDendrite INT := htm.configInt('DataSimpleCountDendrite');
  CountNeuron INT := htm.configInt('DataSimpleCountNeuron');
  CountSynapse INT := htm.configInt('DataSimpleCountSynapse');
  WidthInput INT := htm.configInt('DataSimpleWidthInput');
  InputPerColumn INT := ROUND(WidthInput / CountColumn);
  InputColumnCenter INT := ROUND((WidthInput / CountColumn) / 2);
  SynapseCenter INT := ROUND(CountSynapse / 2);
  SynapseStart INT := CountDendrite * CountNeuron * CountSynapse;
  IndexDiff INT := ROUND(InputColumnCenter - SynapseCenter);
  currentIndex INT;
  linkId INT;
BEGIN
  FOR localColumnId IN 1..CountColumn LOOP
    currentIndex := ((localColumnId - 1) * InputPerColumn) + IndexDiff;
    FOR localSynapseId IN 1..CountSynapse LOOP
      linkId := htm.countUnloop(localColumnId, localSynapseId, CountSynapse);
      INSERT
        INTO htm.link_input_synapse(id, input_index, synapse_id)
        VALUES (
          linkId, 
          htm.wrapArrayIndex(currentIndex, WidthInput), 
          SynapseStart + linkId
        );
      currentIndex := currentIndex + 1;
    END LOOP;
  END LOOP;
END
$$;

