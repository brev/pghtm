#!/bin/sh
SQL=".."
DATA="$SQL/data/table"

psql -f $DATA/config.sql
psql -f $DATA/region.sql
psql -f $DATA/column.sql
psql -f $DATA/cell.sql
psql -f $DATA/segment.sql
psql -f $DATA/synapse.sql
psql -f $DATA/input.sql
psql -f $DATA/link_distal_segment_cell.sql
psql -f $DATA/link_distal_cell_synapse.sql
psql -f $DATA/link_proximal_segment_column.sql
psql -f $DATA/link_proximal_input_synapse.sql

