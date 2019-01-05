#!/bin/sh
SQL=".."
DATA="$SQL/data"

psql -f $DATA/region.sql
psql -f $DATA/column.sql
psql -f $DATA/neuron.sql
psql -f $DATA/dendrite.sql
psql -f $DATA/synapse.sql
psql -f $DATA/input.sql
psql -f $DATA/link_dendrite_column.sql
psql -f $DATA/link_dendrite_neuron.sql
psql -f $DATA/link_input_synapse.sql
psql -f $DATA/link_neuron_synapse.sql
psql -f $DATA/spatial_pooler.sql

