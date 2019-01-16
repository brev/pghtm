/**
 * Constants Data
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
  RAISE NOTICE 'Inserting Constants...';
  
  INSERT INTO htm.constant (
    column_count,
    column_threshold,
    dendrite_count,
    input_width,
    neuron_count,
    potential_pct,
    row_count,
    synapse_count
  )
  VALUES (
    -- column_count: # of columms per region
    width, 
  
    -- column_threshold: Number of top active columns to win 
    --  during Inhibition - IDEAL 2%
    --  nupic sp:numActiveColumnsPerInhArea
    colWin,
  
    -- dendrite_count: # of dendrites per neuron
    4, 
  
    -- input_width: Input SDR Bit Width 
    width,
      
    -- neuron_count: # of neurons per region (rows x cols)
    cells,
      
    -- potential_pct: % input bits each column may connect
    spread,
      
    -- row_count: # of rows per region
    height,
      
    -- synapse_count: # of synapses per dendrite 
    synapses
  );
END
$$;

