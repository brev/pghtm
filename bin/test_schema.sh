#!/bin/sh
SQL=".."
SCHEMA="$SQL/schema"

pg_prove --recurse $SCHEMA/**/*.test.sql

