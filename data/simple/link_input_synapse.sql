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
  SynapseStart INT := CountDendrite * CountNeuron * CountSynapse;
  linkId INT;
BEGIN
  FOR localColumnId IN 1..CountColumn LOOP
    FOR localSynapseId IN 1..CountSynapse LOOP
      linkId := htm.count_unloop(localColumnId, localSynapseId, CountSynapse);
      INSERT
        INTO htm.link_input_synapse(id, input_index, synapse_id)
        VALUES (
          linkId, 
          htm.random_range_int(1, WidthInput), 
          SynapseStart + linkId
        );
    END LOOP;
  END LOOP;
END
$$;

