/**
 * Config Table
 *  - Repeated Constants on top.
 *  - Individual Statics inline body.
 *  - Computed Variables on bottom.
 */
DO
$$
DECLARE
  /* Constants */

  -- height: Region/Column height # neuron rows
  height CONSTANT INT := 1;

  -- width: Region/Column/Input width # neuron cols/bits
  width CONSTANT INT := 100;

  -- synapse_spread_pct: Synapse spread, to calc # of synapses per dendrite
  synapse_spread_pct CONSTANT NUMERIC := 0.5;
BEGIN
  /* Statics */

  EXECUTE FORMAT($sql$
    CREATE TABLE htm.config(
      id INT NOT NULL PRIMARY KEY DEFAULT 1,

      -- column_active_limit: Number of top active columns to win
      --  during Inhibition - IDEAL 2 pct.
      --  nupic sp:numActiveColumnsPerInhArea "kth nearest score"
      --  @SpatialPooler
      column_active_limit INT NOT NULL DEFAULT %L,  -- $1

      -- column_boost_strength: SP Boosting strength
      --  nupic sp:boostStrength
      --  @SpatialPooler
      column_boost_strength NUMERIC NOT NULL DEFAULT 1.2,

      -- column_count: # of columms per region
      column_count INT NOT NULL DEFAULT %L,  -- $2

      -- column_duty_cycle_period: Duty cycle period
      --  nupic sp:dutyCyclePeriod
      --  @SpatialPooler
      column_duty_cycle_period INT NOT NULL DEFAULT 1000,

      -- column_inhibit: SP global inhibition flag
      --  @SpatialPooler
      column_inhibit BOOL NOT NULL DEFAULT TRUE,

      -- debug: output warn notices and do helpful/slow debugging?
      debug BOOL NOT NULL DEFAULT FALSE,

      -- dendrite_count: # of dendrites per neuron
      dendrite_count INT NOT NULL DEFAULT 4,

      -- dendrite_synapse_threshold: # active synapses required for an
      --  active dendrite. Can be used like a low-pass noise filter.
      --  nupic sp:stimulusThreshold=0
      --  nupic tm:?=?
      dendrite_synapse_threshold INT NOT NULL DEFAULT 1,

      -- input_width: Input SDR Bit Width
      --  @SpatialPooler
      input_width INT NOT NULL DEFAULT %L,  -- $3

      -- neuron_count: # of neurons per region (rows x cols)
      neuron_count INT NOT NULL DEFAULT %L,  -- $4

      -- row_count: # of neuron rows high in each column/region
      --  1  = First-order memory, better for static spatial inference
      --  2+ = Variable-order memory, better for dynamic temporal inference
      row_count INT NOT NULL DEFAULT %L,  -- $5,

      -- synapse_count: # of synapses per dendrite
      synapse_count INT NOT NULL DEFAULT %L,  -- $6,

      -- synapse_distal_learn: TM learning on? flag
      --  @TemporalMemory
      synapse_distal_learn BOOL NOT NULL DEFAULT TRUE,

      -- synapse_distal_decrement: Synapse learning permanence decrement
      --  nupic tm:?
      --  @TemporalMemory
      synapse_distal_decrement NUMERIC NOT NULL DEFAULT 0.01,

      -- synapse_distal_increment: Synapse learning permanence increment
      --  nupic tm:?
      --  @TemporalMemory
      synapse_distal_increment NUMERIC NOT NULL DEFAULT 0.01,

      -- synapse_distal_spread_pct: pct input bits each column may connect
      --  @TemporalMemory
      synapse_distal_spread_pct NUMERIC NOT NULL DEFAULT %L,  -- $7

      -- synapse_distal_threshold: Synapse connect permanence threshold
      --  > is connected, <= is potential
      --  nupic tm:connectedPerm=0.5
      --  @TemporalMemory
      synapse_distal_threshold NUMERIC NOT NULL DEFAULT 0.5,

      -- synapse_proximal_learn: SP learning on? flag
      --  @SpatialPooler
      synapse_proximal_learn BOOL NOT NULL DEFAULT TRUE,

      -- synapse_proximal_decrement: Synapse learning permanence decrement
      --  nupic sp:synPermActiveDec
      --  @SpatialPooler
      synapse_proximal_decrement NUMERIC NOT NULL DEFAULT 0.01,

      -- synapse_proximal_increment: Synapse learning permanence increment
      --  nupic sp:synPermActiveInc
      --  @SpatialPooler
      synapse_proximal_increment NUMERIC NOT NULL DEFAULT 0.01,

      -- synapse_proximal_spread_pct: pct input bits each column may connect
      --  nupic sp:potentialPct "receptive field"
      --  @SpatialPooler
      synapse_proximal_spread_pct NUMERIC NOT NULL DEFAULT %L,  -- $8

      -- synapse_proximal_threshold: Synapse connect permanence threshold
      --  > is connected, <= is potential
      --  nupic sp:synPermConnected=0.1
      --  @SpatialPooler
      synapse_proximal_threshold NUMERIC NOT NULL DEFAULT 0.1,

      CHECK (id = 1)
    );
  $sql$,
    /* Computed Variables */

    -- $1 column_active_limit
    (width * 0.04)::INT,

    -- $2 column_count
    width,

    -- $3 input_width
    width,

    -- $4 neuron_count
    (height * width)::INT,

    -- $5 row_count
    height,

    -- $6 synapse_count
    (width * synapse_spread_pct)::INT,

    -- $7 synapse_distal_spread_pct
    synapse_spread_pct,

    -- $8 synapse_proximal_spread_pct
    synapse_spread_pct
  );
END
$$;

