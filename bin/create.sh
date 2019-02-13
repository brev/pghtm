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

# functions
psql -f $SCHEMA/function/config.sql
psql -f $SCHEMA/function/htm.sql
psql -f $SCHEMA/function/region.sql
psql -f $SCHEMA/function/column.sql
psql -f $SCHEMA/function/cell.sql
psql -f $SCHEMA/function/segment.sql
psql -f $SCHEMA/function/synapse_distal.sql
psql -f $SCHEMA/function/synapse_proximal.sql
psql -f $SCHEMA/function/input.sql

# tables
psql -f $SCHEMA/table/config.sql
psql -f $SCHEMA/table/region.sql
psql -f $SCHEMA/table/column.sql
psql -f $SCHEMA/table/cell.sql
psql -f $SCHEMA/table/segment.sql
psql -f $SCHEMA/table/synapse_distal.sql
psql -f $SCHEMA/table/synapse_proximal.sql
psql -f $SCHEMA/table/input.sql

# sequences
psql -f $SCHEMA/sequence/htm.sql

# views
psql -f $SCHEMA/view/synapse_proximal_connect.sql
psql -f $SCHEMA/view/synapse_proximal_active.sql
psql -f $SCHEMA/view/synapse_distal_connect.sql
psql -f $SCHEMA/view/synapse_distal_active.sql
psql -f $SCHEMA/view/segment_active.sql
psql -f $SCHEMA/view/segment_anchor.sql
psql -f $SCHEMA/view/cell_predict.sql
psql -f $SCHEMA/view/cell_burst.sql
psql -f $SCHEMA/view/cell_anchor.sql
psql -f $SCHEMA/view/column_overlap_boost.sql

# triggers
psql -f $SCHEMA/trigger/config.sql
psql -f $SCHEMA/trigger/region.sql
psql -f $SCHEMA/trigger/column.sql
psql -f $SCHEMA/trigger/cell.sql
psql -f $SCHEMA/trigger/synapse_distal.sql
psql -f $SCHEMA/trigger/synapse_proximal.sql
psql -f $SCHEMA/trigger/input.sql

