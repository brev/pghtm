# pgHTM


## Installation


### Requirements

#### User & Production

* PostgreSQL - Database Engine
* pgHTM - This Schema

#### Admin & Visualization

* Docker - Container Engine
* Node.js & npm/Yarn - Javscript Engine
* Hasura - GraphQL API Layer for Postgres
* React (create-react-app) - Web Browser UI Engine

#### Development & Testing

* Perl & CPAN - Perl Engine
* Ruby, Gems, Activerecord - Ruby Engine
* pgTAP + pg_prove - Unit Testing (everything)
* piggly - Code Coverage (plpgsql functions only)


### Instructions

#### Development @ Mac OS/X

Reccomended Sources:
* brew => Postgres, Node, Ruby
* brew cask => Docker
* osx => Perl

```bash
cd src/

# postgres
brew install postgresql
export DBNAME=`whoami`  # db name is username (simple default)
createdb $DBNAME

# pgtap
git clone https://github.com/theory/pgtap.git
cd pgtap/
make
make installcheck
make install
psql -c "CREATE EXTENSION pgtap;"
cd ..

# pg_prove
sudo cpan App::cpanminus
sudo cpan Test::Pod::Coverage
sudo cpan TAP::Parser::SourceHandler::pgTAP

# pgHTM
cd pghtm/bin/
./create.sh
./fill.sh
./test_schema.sh
./test_data_init.sh
cd ..

# piggly
gem install piggly
gem install activerecord
## Modify pghtm/test/config/database.yml. Use DBNAME, etc.
piggly trace --select /htm/ --database test/config/database.yml
cd bin/
./test_schema.sh 2> ../piggly/coverage.txt
./test_data_init.sh 2>> ../piggly/coverage.txt
cd ..
piggly untrace --select /htm/ --database test/config/database.yml
piggly report --select /htm/ -f piggly/coverage.txt
## Open in Browser: piggly/reports/index.html

# hasura graphql
cd viz/
cd graphql/
## Modify docker-run.sh, set HASURA_GRAPHQL_DATABASE_URL.
##  On Mac: postgres://USERNAME@host.docker.internal:5432/DBNAME
./docker-run.sh
## Open graphql layer in Browser: http://localhost:8080/console
##  Select DATA tab, change Schema to "htm", follow auto-import.
cd ../
cd webui/
npm start
## Open web UI layer in Browser: http://localhost:3000
```

