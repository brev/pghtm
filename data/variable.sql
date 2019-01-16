/**
 * Variable Data
 */
DO
$$
BEGIN
  RAISE NOTICE 'Inserting Variables...';

  INSERT INTO htm.variable (
    boost_strength,
    dendrite_threshold,
    duty_cycle_period,
    inhibition,
    logging,
    sp_learn,
    synapse_decrement,
    synapse_increment,
    synapse_threshold
  )
  VALUES (
    -- boost_strength: SP Boosting strength
    1.5,

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
 
    -- logging: output warn notices for debug logging?
    FALSE,
 
    -- sp_learn: SP learning on? 1=true, 0=false
    1,

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

