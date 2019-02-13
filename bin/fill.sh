#!/bin/sh
SQL=".."
DATA="$SQL/data/table"

psql -f $DATA/config.sql
psql -f $DATA/region.sql
psql -f $DATA/column.sql
psql -f $DATA/cell.sql
psql -f $DATA/segment.sql
psql -f $DATA/synapse_distal.sql
psql -f $DATA/synapse_proximal.sql
psql -f $DATA/input.sql

