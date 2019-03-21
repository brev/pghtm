#!/bin/sh
SQL=".."
DATA="$SQL/data"

pg_prove --recurse $DATA/**/*.test.sql

