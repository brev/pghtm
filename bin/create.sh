#!/bin/sh
SQL=".."
SCHEMA="$SQL/schema"

psql -f $SCHEMA/htm.sql

psql -f $SCHEMA/types/dendrite.sql
psql -f $SCHEMA/types/synapse.sql

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
psql -f $SCHEMA/tables/spatial_pooler.sql

psql -f $SCHEMA/functions/htm.sql
psql -f $SCHEMA/functions/column.sql
psql -f $SCHEMA/functions/synapse.sql
psql -f $SCHEMA/functions/spatial_pooler.sql

psql -f $SCHEMA/triggers/input.sql
psql -f $SCHEMA/triggers/synapse.sql

