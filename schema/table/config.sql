/**
 * Config Table
 *  Use the htm.config() getter (dynamic generated function) to access these
 *    with blazing fast immutable speed.
 */

DO
$$
DECLARE
  -- height: Region/Column height # neuron rows
  height CONSTANT INT := 2;

  -- width: Region/Column/Input width # neuron cols/bits
  width CONSTANT INT := 100;

  -- synapse_spread_pct: Synapse spread, to calc # of synapses per dendrite
  synapse_spread_pct CONSTANT NUMERIC := 0.5;

BEGIN
  EXECUTE FORMAT($sql$
    CREATE TABLE htm.config(
      id INT NOT NULL PRIMARY KEY DEFAULT 1,
      CHECK (id = 1),


      /* CONSTANTS */

      -- column_count: # of columms per region
      column_count INT NOT NULL DEFAULT %1$L,
      CHECK (column_count = %1$L),  -- CONSTANT

      -- dendrite_count: # of dendrites per neuron
      dendrite_count INT NOT NULL DEFAULT 4,
      CHECK (dendrite_count = 4),  -- CONSTANT

      -- input_width: Input SDR Bit Width
      --  @SpatialPooler
      input_width INT NOT NULL DEFAULT %1$L,
      CHECK (input_width = %1$L),  -- CONSTANT

      -- neuron_count: # of neurons per region (rows x cols)
      neuron_count INT NOT NULL DEFAULT %2$L,
      CHECK (neuron_count = %2$L),  -- CONSTANT

      -- row_count: # of neuron rows high in each column/region
      --  1  = First-order memory, better for static spatial inference
      --  2+ = Variable-order memory, better for dynamic temporal inference
      row_count INT NOT NULL DEFAULT %3$L,
      CHECK (row_count = %3$L),  -- CONSTANT

      -- synapse_count: # of synapses per dendrite
      synapse_count INT NOT NULL DEFAULT %4$L,
      CHECK (synapse_count = %4$L),  -- CONSTANT

      -- synapse_distal_spread_pct: pct input bits each column may connect
      --  @TemporalMemory
      synapse_distal_spread_pct NUMERIC NOT NULL DEFAULT %5$L,
      CHECK (synapse_distal_spread_pct = %5$L),  -- CONSTANT

      -- synapse_proximal_spread_pct: pct input bits each column may connect
      --  nupic sp:potentialPct "receptive field"
      --  @SpatialPooler
      synapse_proximal_spread_pct NUMERIC NOT NULL DEFAULT %5$L,
      CHECK (synapse_proximal_spread_pct = %5$L),  -- CONSTANT


      /* VARIABLES */

      -- column_active_limit: Number of top active columns to win
      --  during Inhibition - IDEAL 2 pct.
      --  nupic sp:numActiveColumnsPerInhArea "kth nearest score"
      --  @SpatialPooler
      column_active_limit INT NOT NULL DEFAULT %6$L,

      -- column_boost_strength: SP Boosting strength
      --  nupic sp:boostStrength
      --  @SpatialPooler
      column_boost_strength NUMERIC NOT NULL DEFAULT 1.2,

      -- column_duty_cycle_period: Duty cycle period
      --  nupic sp:dutyCyclePeriod
      --  @SpatialPooler
      column_duty_cycle_period INT NOT NULL DEFAULT 1000,

      -- column_inhibit: SP global inhibition flag
      --  @SpatialPooler
      column_inhibit BOOL NOT NULL DEFAULT TRUE,

      -- debug: output warn notices and do helpful/slow debugging?
      debug BOOL NOT NULL DEFAULT FALSE,

      -- dendrite_synapse_threshold: # active synapses required for an
      --  active dendrite. Can be used like a low-pass noise filter.
      --  nupic sp:stimulusThreshold=0
      --  nupic tm:?=?
      dendrite_synapse_threshold INT NOT NULL DEFAULT 0,

      -- neuron_dendrite_threshold: # active distal dendrites required for a
      --  predictive neuron. Default of 0 acts like NuPIC-suggested LOGICAL OR.
      --  nupic tm:?=?
      neuron_dendrite_threshold INT NOT NULL DEFAULT 0,

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

      -- synapse_proximal_threshold: Synapse connect permanence threshold
      --  > is connected, <= is potential
      --  nupic sp:synPermConnected=0.1
      --  @SpatialPooler
      synapse_proximal_threshold NUMERIC NOT NULL DEFAULT 0.1
    );
  $sql$,
    /* Substitutions */

    -- 1$ column_count, input_width
    width,

    -- 2$ neuron_count
    (height * width)::INT,

    -- 3$ row_count
    height,

    -- 4$ synapse_count
    (width * synapse_spread_pct)::INT,

    -- 5$ synapse_distal_spread_pct, synapse_proximal_spread_pct
    synapse_spread_pct,

    -- 6$ column_active_limit
    (width * 0.04)::INT
  );
END
$$;

