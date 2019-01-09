#!/bin/sh

##
# Create pgHTM DB Schema.
#   Order matters below.
##

SQL=".."
SCHEMA="$SQL/schema"


# schema
psql -f $SCHEMA/htm.sql

# types
psql -f $SCHEMA/types/dendrite.sql

# tables
psql -f $SCHEMA/tables/region.sql
psql -f $SCHEMA/tables/column.sql
psql -f $SCHEMA/tables/neuron.sql
psql -f $SCHEMA/tables/dendrite.sql
psql -f $SCHEMA/tables/synapse.sql
psql -f $SCHEMA/tables/input.sql
psql -f $SCHEMA/tables/link_dendrite_column.sql
psql -f $SCHEMA/tables/link_dendrite_neuron.sql
psql -f $SCHEMA/tables/link_input_synapse.sql
psql -f $SCHEMA/tables/link_neuron_synapse.sql

# functions
psql -f $SCHEMA/functions/htm.sql
psql -f $SCHEMA/functions/dendrite.sql
psql -f $SCHEMA/functions/input.sql
psql -f $SCHEMA/functions/synapse.sql
#psql -f $SCHEMA/functions/spatial_pooler.sql

# triggers
psql -f $SCHEMA/triggers/input.sql

# views
psql -f $SCHEMA/views/synapse.sql
psql -f $SCHEMA/views/dendrite.sql  # must follow views/synapse

