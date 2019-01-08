# pgHTM

Hierarchical Temporal Memory (HTM) in PostgreSQL.

**PRIVATE! Not yet for public consumption.**


## Requirements

### Production / Users

* PostgreSQL - Database Engine
* pgHTM - This Schema

### Development & Testing

* Perl & CPAN - Perl Engine
* Ruby, Gems, Activerecord - Ruby Engine
* pgTAP + pg_prove - Unit Testing (full schema)
* piggly - Code Coverage (plpgsql functions only)

### Admin / Visualization

* Docker - Container Engine
* Node.js & npm or yarn - Javscript Engine
* Hasura - GraphQL API Layer for Postgres
* React (create-react-app) - Web Browser UI Engine


## Installation

### Development @ Mac OS/X

Reccomended Sources:
* **System**: Perl
* **Homebrew**: Postgres, Ruby, Node.js
* **Homebrew Cask**: Docker

```bash
# clone repo into pghtm/ subdir of your src/ code dir
pushd src/
git clone git@github.com:brev/pghtm.git

# postgres - db engine
brew install postgresql
pg_ctl -D /usr/local/var/postgres start   # start postgres
export PGDATABASE=htmdb   # important! psql client & scripts expecting this
createdb

# pgtap - sql unit testing
git clone https://github.com/theory/pgtap.git
pushd pgtap/
make
make installcheck
make install
psql -c "CREATE EXTENSION pgtap;"
## pg_prove - sql unit testing tool (TODO ditch `sudo` somehow)
sudo cpan App::cpanminus
sudo cpan Test::Pod::Coverage
sudo cpan TAP::Parser::SourceHandler::pgTAP
popd

# pgHTM - this schema
pushd pghtm/
pushd bin/
./create.sh
./fill.sh
./test_schema.sh
./test_data_init.sh
popd

# piggly - plpgsql code coverage reporting
brew install ruby
## Hack on GEM_HOME and GEM_PATH env vars to get homebrew ruby+gems working.
gem install piggly activerecord
## Modify pghtm/test/config/database.yml, update with DB connection info.
piggly trace --select /htm/ --database test/config/database.yml
pushd bin/
./test_schema.sh 2> ../piggly/coverage.txt
./test_data_init.sh 2>> ../piggly/coverage.txt
popd
piggly untrace --select /htm/ --database test/config/database.yml
piggly report --select /htm/ -f piggly/coverage.txt
## Open in Browser: piggly/reports/index.html

# hasura - graphql layer on top of postgres for webui viz
brew cask install docker
## Start Docker.app from your Mac GUI Applications folder
pushd viz/graphql/
## Modify docker-run.sh, set HASURA_GRAPHQL_DATABASE_URL to DB connection info.
##  On Mac, like: postgres://USERNAME@host.docker.internal/htmdb
./docker-run.sh
popd
## Open graphql layer in Browser: http://localhost:8080/console
##  Select DATA tab, change Schema to "htm". Use buttons to Add All Tables, 
##  and Track All Relations.

# web ui - visualize htm state via graphql
pushd viz/webui/
npm install
npm start
popd
## Open web UI layer in Browser: http://localhost:3000/spatialpooler/

# Usage: pgHTM
## Run 1 test compute cycle (Spatial Pooler) on row put in `input` table.
##  FYI: After this, the initial data tests (above) will no longer pass.
psql -c "INSERT INTO htm.input (indexes) VALUES (ARRAY[0,1,2,3])"
```

