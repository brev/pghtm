#!/bin/sh
SQL=".."
TESTS="$SQL/tests"

pg_prove --ext=.sql --recurse $TESTS/schema/

