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
psql -f $SCHEMA/type/dendrite_class.sql

# functions
psql -f $SCHEMA/function/config.sql
psql -f $SCHEMA/function/htm.sql
psql -f $SCHEMA/function/region.sql
psql -f $SCHEMA/function/column.sql
psql -f $SCHEMA/function/neuron.sql
psql -f $SCHEMA/function/dendrite.sql
psql -f $SCHEMA/function/synapse.sql
psql -f $SCHEMA/function/input.sql

# tables
psql -f $SCHEMA/table/config.sql
psql -f $SCHEMA/table/region.sql
psql -f $SCHEMA/table/column.sql
psql -f $SCHEMA/table/neuron.sql
psql -f $SCHEMA/table/dendrite.sql
psql -f $SCHEMA/table/synapse.sql
psql -f $SCHEMA/table/input.sql
psql -f $SCHEMA/table/link_distal_dendrite_neuron.sql
psql -f $SCHEMA/table/link_distal_neuron_synapse.sql
psql -f $SCHEMA/table/link_proximal_dendrite_column.sql
psql -f $SCHEMA/table/link_proximal_input_synapse.sql

# views
psql -f $SCHEMA/view/synapse_proximal_connect.sql
psql -f $SCHEMA/view/synapse_proximal_active.sql
psql -f $SCHEMA/view/synapse_distal_connect.sql
psql -f $SCHEMA/view/synapse_distal_active.sql
psql -f $SCHEMA/view/dendrite_proximal_overlap_active.sql
psql -f $SCHEMA/view/dendrite_distal_active.sql
psql -f $SCHEMA/view/neuron_distal_predict.sql
psql -f $SCHEMA/view/neuron_proximal_burst.sql
psql -f $SCHEMA/view/column_overlap_boost.sql

# triggers
psql -f $SCHEMA/trigger/config.sql
psql -f $SCHEMA/trigger/input.sql
psql -f $SCHEMA/trigger/column.sql

