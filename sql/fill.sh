#!/bin/sh

psql -f data/simple/region.sql
psql -f data/simple/neuron.sql
psql -f data/simple/dendrite.sql
psql -f data/simple/synapse.sql

