/**
 * Link: Axon from Input to Synapse Data
 */

DO
$$
DECLARE
  CountColumn INT := htm.config('CountColumn');
  CountDendrite INT := htm.config('CountDendrite');
  CountNeuron INT := htm.config('CountNeuron');
  CountSynapse INT := htm.config('CountSynapse');
  WidthInput INT := htm.config('WidthInput');
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
      linkId := htm.count_unloop(localColumnId, localSynapseId, CountSynapse);
      INSERT
        INTO htm.link_input_synapse(id, input_index, synapse_id)
        VALUES (
          linkId, 
          htm.wrap_array_index(currentIndex, WidthInput), 
          SynapseStart + linkId
        );
      currentIndex := currentIndex + 1;
    END LOOP;
  END LOOP;
END
$$;

