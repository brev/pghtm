/**
 * Variable Data
 */

INSERT INTO htm.variable (
    boostStrength,
    DendriteThreshold,
    dutyCyclePeriod,
    inhibition,
    spLearn,
    SynapseDecrement,
    SynapseIncrement,
    SynapseThreshold
  )
  VALUES (
    -- boostStrength: SP Boosting strength
    1.5,

    -- DendriteThreshold: # active synapses needed for an active dendrite. 
    --  Can be used like a low-pass noise filter.
    --  nupic sp:stimulusThreshold=0
    1,
  
    -- dutyCyclePeriod: Duty cycle period
    1000,
  
    -- inhibition: SP inhibition type:
    --  0=off
    --  1=global
    --  2=local (TODO not built yet) 
    1,
  
    -- spLearn: SP learning on? 1=true, 0=false
    1,

    -- SynapseDecrement: Synapse learning permanence decrement
    --  nupic sp:synPermActiveDec
    0.01,

    -- SynapseIncrement: Synapse learning permanence increment
    --  nupic sp:synPermActiveInc
    0.01,      

    -- SynapseThreshold: Synapse connect permanence threshold
    --  > is connected, <= is potential
    --  nupic sp:synPermConnected=0.1
    --  nupic tp:connectedPerm=0.5
    0.3
  );

