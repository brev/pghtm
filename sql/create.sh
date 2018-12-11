#!/bin/sh

psql -f schema/htm.sql

psql -f schema/types/neuron.sql
psql -f schema/types/dendrite.sql

psql -f schema/tables/region.sql
psql -f schema/tables/neuron.sql
psql -f schema/tables/dendrite.sql
psql -f schema/tables/synapse.sql

psql -f schema/functions/dendrite.sql
psql -f schema/functions/synapse.sql

psql -f schema/views/synapse_connected.sql
psql -f schema/views/dendrite_activated.sql

