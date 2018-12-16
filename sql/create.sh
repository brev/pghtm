#!/bin/sh
SQL="./"
SCHEMA="$SQL/schema"

psql -f $SCHEMA/htm.sql

psql -f $SCHEMA/types/neuron.sql

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

psql -f $SCHEMA/functions/htm.sql
psql -f $SCHEMA/functions/dendrite.sql
psql -f $SCHEMA/functions/synapse.sql

#psql -f $SCHEMA/views/synapse_connected.sql
#psql -f $SCHEMA/views/dendrite_activated.sql

