#!/bin/sh
SQL=".."
TESTS="$SQL/test"

pg_prove --ext=.sql --recurse $TESTS/schema/

