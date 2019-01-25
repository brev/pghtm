#!/bin/sh

SQL=".."
DATA="$SQL/data"
SCHEMA="$SQL/schema"

####
## Create HTM DB Schema.
##  Sort order matters below.
####

# schema
psql -f $SCHEMA/htm.sql

# types
psql -f $SCHEMA/types/dendrite.sql

# functions
psql -f $SCHEMA/functions/config.sql
psql -f $SCHEMA/functions/htm.sql
psql -f $SCHEMA/functions/region.sql
psql -f $SCHEMA/functions/column.sql
psql -f $SCHEMA/functions/neuron.sql
psql -f $SCHEMA/functions/dendrite.sql
psql -f $SCHEMA/functions/synapse.sql
psql -f $SCHEMA/functions/input.sql

# tables
psql -f $SCHEMA/tables/config.sql
psql -f $SCHEMA/tables/region.sql
psql -f $SCHEMA/tables/column.sql
psql -f $SCHEMA/tables/neuron.sql
psql -f $SCHEMA/tables/dendrite.sql
psql -f $SCHEMA/tables/synapse.sql
psql -f $SCHEMA/tables/input.sql
psql -f $SCHEMA/tables/link_distal_dendrite_neuron.sql
psql -f $SCHEMA/tables/link_distal_neuron_synapse.sql
psql -f $SCHEMA/tables/link_proximal_dendrite_column.sql
psql -f $SCHEMA/tables/link_proximal_input_synapse.sql

# views
psql -f $SCHEMA/views/synapse_proximal_connect.sql
psql -f $SCHEMA/views/synapse_proximal_active.sql
psql -f $SCHEMA/views/synapse_distal_connect.sql
psql -f $SCHEMA/views/synapse_distal_active.sql
psql -f $SCHEMA/views/dendrite_proximal_overlap_active.sql
psql -f $SCHEMA/views/dendrite_distal_active.sql
psql -f $SCHEMA/views/neuron_distal_predict.sql
psql -f $SCHEMA/views/neuron_proximal_burst.sql
psql -f $SCHEMA/views/column_overlap_boost.sql
psql -f $SCHEMA/views/column_active.sql

# triggers
psql -f $SCHEMA/triggers/config.sql
psql -f $SCHEMA/triggers/input.sql
psql -f $SCHEMA/triggers/column.sql

