# pgHTM

[Hierarchical Temporal Memory](https://www.numenta.com/machine-intelligence-technology/) 
(HTM) in PostgreSQL.

**PRIVATE! Not yet for public consumption.**


# About

Machine Intelligence Neuro-technology. BLAH BLAH.

* [ ] Encoders
* [x] Spatial Pooler
* [ ] Temporal Memory


# Install

## Requirements

### Main

* [PostgreSQL](https://www.postgresql.org/) Backend

### Test

* Unit Testing:
  * [Perl](https://www.perl.org/)
  * [pgTAP](https://pgtap.org/) + pg_prove
* Code Coverage ([plpgsql](https://en.wikipedia.org/wiki/PL/pgSQL)):
  * [Ruby](https://www.ruby-lang.org/)
  * [piggly](http://kputnam.github.io/piggly/) + activerecord

### Web UI

* [GraphQL](https://graphql.org/) Midddleware
  * [Docker](https://www.docker.com/)
  * [Hasura](https://hasura.io/)
* Web Frontend
  * [Node.js](https://nodejs.org/)
  * [React](https://reactjs.org/) 
      ([create-react-app](https://facebook.github.io/create-react-app/))

## Development
 
### Mac OS/X Darwin

* Expecting: [Homebrew](https://brew.sh/)

#### Main

```bash
brew install postgresql pgcli
pg_ctl -D /usr/local/var/postgres restart
export PGDATABASE=htmdb   # important! psql client & scripts expecting this
createdb

cd src   # your repo checkout parent dir
git clone git@github.com:brev/pghtm.git
cd pghtm/bin
./create.sh
./fill.sh
cd ../..
```

#### Test

Expecting:
* OS/X default system Perl

Unit Testing:

```bash
git clone https://github.com/theory/pgtap.git
cd pgtap
make
make installcheck
make install
psql -c "CREATE EXTENSION pgtap;"
sudo cpan App::cpanminus  # TODO ditch sudo somehow
sudo cpan Test::Pod::Coverage
sudo cpan TAP::Parser::SourceHandler::pgTAP
cd ..

cd pghtm/bin
./test_schema.sh
./test_data_init.sh
cd ../..
```

Code Coverage:

```bash
brew install ruby 
## Modify GEM_HOME and GEM_PATH env vars to get homebrew ruby+gems working
gem install piggly activerecord

cd pghtm
## Modify pghtm/test/config/database.yml, update DB connection info
piggly trace --select /htm/ --database test/config/database.yml
cd bin
./test_schema.sh 2> ../piggly/coverage.txt
./test_data_init.sh 2>> ../piggly/coverage.txt
cd ..
piggly untrace --select /htm/ --database test/config/database.yml
piggly report --select /htm/ -f piggly/coverage.txt
## Open in Browser: piggly/reports/index.html
cd ..
```

#### Web UI

```bash
brew cask install docker
brew install node

cd pghtm/webui

## Modify docker-run.sh, set HASURA_GRAPHQL_DATABASE_URL to DB connection info
##  On Mac, like: postgres://USERNAME@host.docker.internal/htmdb
./docker-run.sh
## Open graphql layer in Browser: http://localhost:8080/console
##  Select DATA tab, change Schema to "htm". Use buttons to Add All Tables, 
##  and Track All Relations.

npm install
npm start
## Open web UI layer in Browser: http://localhost:3000/spatialpooler/
```


# Usage

* After first use, the initial data tests (above) will no longer pass.
* Try the more modern `pgcli` client instead of stock `psql`.

```bash
psql

INSERT INTO htm.input (indexes) VALUES (ARRAY[0,1,2,3]);
# INSERT 0 1

SELECT indexes, columns_active FROM htm.input;
#    indexes   | columns_active
# -------------+----------------
#  {0,1,2,3,4} | {28,31,46,72}
# (1 row)

\q
```


# Debug

```bash
psql

\timing on
# Timing is on.

UPDATE htm.config SET logging = TRUE;
# UPDATE 1
# Time: 2.184 ms

EXPLAIN ANALYZE VERBOSE INSERT INTO htm.input (indexes) VALUES (ARRAY[0,1,2,3]);
# Lots of Info

LOAD 'auto_explain';
SET auto_explain.log_nested_statements = ON;
SET auto_explain.log_min_duration = 0;
# Run a query, Even more Info

SET auto_explain.log_analyze  = TRUE;
# Run a query, Ludicrous amounts of Info
```

