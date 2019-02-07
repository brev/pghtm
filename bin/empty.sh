#!/bin/sh
SQL="."
SCHEMA="../schema"

psql -f $SQL/sql/empty.sql
psql -f $SCHEMA/sequence/htm.sql

