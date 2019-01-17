/**
 * Config Data
 */
DO
$$
DECLARE
  /* const */
  -- Region/Column/Input height # rows
  height CONSTANT INTEGER := 1;

  -- % SP winner columns not inhibited
  pctColWin CONSTANT NUMERIC := 0.04;

  -- SP col can connect to this % of input
  spread CONSTANT NUMERIC := 0.5;

  -- Region/Input width # cols
  width CONSTANT INTEGER := 100;

  /* calc */
  -- Total count of neurons
  cells CONSTANT INTEGER := height * width;

  -- # SP win cols not inhibited
  colWin CONSTANT INTEGER := width * pctColWin;

  -- Synapses per Dendrite
  synapses CONSTANT INTEGER := width * spread;
BEGIN
  RAISE NOTICE 'Inserting Config...';

  INSERT INTO htm.config (
    boost_strength,
    column_count,
    column_threshold,
    dendrite_count,
    dendrite_threshold,
    duty_cycle_period,
    inhibition,
    input_width,
    logging,
    neuron_count,
    potential_pct,
    row_count,
    sp_learn,
    synapse_count,
    synapse_decrement,
    synapse_increment,
    synapse_threshold
  )
  VALUES (
    -- boost_strength: SP Boosting strength
    1.5,

    -- column_count (readonly): # of columms per region
    width,

    -- column_threshold: Number of top active columns to win
    --  during Inhibition - IDEAL 2%
    --  nupic sp:numActiveColumnsPerInhArea
    colWin,

    -- dendrite_count (readonly): # of dendrites per neuron
    4,

    -- dendrite_threshold: # active synapses needed for an active dendrite.
    --  Can be used like a low-pass noise filter.
    --  nupic sp:stimulusThreshold=0
    1,

    -- duty_cycle_period: Duty cycle period
    1000,

    -- inhibition: SP inhibition type:
    --  0=off
    --  1=global
    --  2=local (TODO not built yet)
    1,

    -- input_width (readonly): Input SDR Bit Width
    width,

    -- logging: output warn notices for debug logging?
    FALSE,

    -- neuron_count (readonly): # of neurons per region (rows x cols)
    cells,

    -- potential_pct: % input bits each column may connect
    spread,

    -- row_count (readonly): # of rows per region
    height,

    -- sp_learn: SP learning on? flag
    TRUE,

    -- synapse_count (readonly): # of synapses per dendrite
    synapses,

    -- synapse_decrement: Synapse learning permanence decrement
    --  nupic sp:synPermActiveDec
    0.01,

    -- synapse_increment: Synapse learning permanence increment
    --  nupic sp:synPermActiveInc
    0.01,

    -- synapse_threshold: Synapse connect permanence threshold
    --  > is connected, <= is potential
    --  nupic sp:synPermConnected=0.1
    --  nupic tp:connectedPerm=0.5
    0.3
  );
END
$$;

