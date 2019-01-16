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
    ColumnCount,
    ColumnThreshold,
    DendriteCount,
    InputWidth,
    NeuronCount,
    potentialPct,
    RowCount,
    SynapseCount
  )
  VALUES (
    -- ColumnCount: # of columms per region
    width, 
  
    -- ColumnThreshold: Number of top active columns to win 
    --  during Inhibition - IDEAL 2%
    --  nupic sp:numActiveColumnsPerInhArea
    colWin,
  
    -- DendriteCount: # of dendrites per neuron
    4, 
  
    -- InputWidth: Input SDR Bit Width 
    width,
      
    -- NeuronCount: # of neurons per region (rows x cols)
    cells,
      
    -- potentialPct: % input bits each column may connect
    spread,
      
    -- RowCount: # of rows per region
    height,
      
    -- SynapseCount: # of synapses per dendrite 
    synapses
  );
END
$$;

