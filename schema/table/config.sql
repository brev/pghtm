/**
 * Config Table
 *  Use the htm.config() getter (dynamic generated function) to access these
 *    with blazing fast immutable speed.
 */
DO
$$
DECLARE
  -- height: Region/Column height # cell rows
  height CONSTANT INT := 2;

  -- width: Region/Column/Input width # cell cols/bits
  width CONSTANT INT := 100;

  -- synapse_distal_spread_pct: Pct spread cells,
  --  for calc # distal synapses per segment
  synapse_distal_spread_pct CONSTANT NUMERIC := 0.5;

  -- synapse_proximal_spread_pct: Pct spread input bits,
  --  for calc # proximal synapses per column
  synapse_proximal_spread_pct CONSTANT NUMERIC := 0.5;

BEGIN
  EXECUTE FORMAT($sql$
    CREATE TABLE htm.config(
      id INT NOT NULL PRIMARY KEY DEFAULT 1,
      CHECK (id = 1),


      /* CONSTANTS */

      -- column_count: # of columms per region
      column_count INT NOT NULL DEFAULT %1$L,
      CHECK (column_count = %1$L),  -- CONSTANT

      -- segment_count: # of segments per cell
      segment_count INT NOT NULL DEFAULT 4,
      CHECK (segment_count = 4),  -- CONSTANT

      -- input_width: Input SDR Bit Width
      --  @SpatialPooler
      input_width INT NOT NULL DEFAULT %1$L,
      CHECK (input_width = %1$L),  -- CONSTANT

      -- cell_count: # of cells per region (rows x cols)
      cell_count INT NOT NULL DEFAULT %2$L,
      CHECK (cell_count = %2$L),  -- CONSTANT

      -- row_count: # of cell rows high in each column/region
      --  1  = First-order memory, better for static spatial inference
      --  2+ = Variable-order memory, better for dynamic temporal inference
      row_count INT NOT NULL DEFAULT %3$L,
      CHECK (row_count = %3$L),  -- CONSTANT

      -- synapse_distal_count: # of synapses per distal segment to cell
      --  @TemporalMemory
      synapse_distal_count INT NOT NULL DEFAULT %4$L,
      CHECK (synapse_distal_count = %4$L),  -- CONSTANT

      -- synapse_proximal_count: # synapses per proximal column segment to input
      --  @SpatialPooler
      synapse_proximal_count INT NOT NULL DEFAULT %5$L,
      CHECK (synapse_proximal_count = %5$L),  -- CONSTANT

      -- synapse_distal_spread_pct: pct cells each cell segment may connect to
      --  @TemporalMemory
      synapse_distal_spread_pct NUMERIC NOT NULL DEFAULT %6$L,
      CHECK (synapse_distal_spread_pct = %6$L),  -- CONSTANT

      -- synapse_proximal_spread_pct: pct input bits each column may connect to
      --  nupic sp:potentialPct "receptive field"
      --  @SpatialPooler
      synapse_proximal_spread_pct NUMERIC NOT NULL DEFAULT %7$L,
      CHECK (synapse_proximal_spread_pct = %7$L),  -- CONSTANT


      /* VARIABLES */

      -- column_active_limit: Number of top active columns to win
      --  during Inhibition - IDEAL 2 pct.
      --  nupic sp:numActiveColumnsPerInhArea "kth nearest score"
      --  @SpatialPooler
      column_active_limit INT NOT NULL DEFAULT %8$L,

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

      -- segment_synapse_threshold: # active synapses required for an
      --  active segment. Can be used like a low-pass noise filter.
      --  nupic sp:stimulusThreshold=0
      --  nupic tm:?=?
      segment_synapse_threshold INT NOT NULL DEFAULT 0,

      -- cell_segment_threshold: # active distal segments required for a
      --  predictive cell. Default of 0 acts like NuPIC-suggested LOGICAL OR.
      --  nupic tm:?=?
      cell_segment_threshold INT NOT NULL DEFAULT 0,

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

    -- 2$ cell_count
    (height * width)::INT,

    -- 3$ row_count
    height,

    -- 4$ synapse_distal_count
    (width * synapse_distal_spread_pct)::INT,

    -- 5$ synapse_proximal_count
    (width * synapse_proximal_spread_pct)::INT,

    -- 6$ synapse_distal_spread_pct
    synapse_distal_spread_pct,

    -- 7$ synapse_proximal_spread_pct
    synapse_proximal_spread_pct,

    -- 8$ column_active_limit
    (width * 0.04)::INT
  );
END
$$;

