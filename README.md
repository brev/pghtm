
# Setup


## Requirements

### Production

* PostgreSQL

### Development

* Perl
* pgTAP + pg_prove


## Installation

### Mac OS/X

```bash
cd src/

# postgres
brew install postgresql
createdb `whoami`

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

# pghtm
cd pghtm/
cd bin/
./create.sh
./fill.sh
cd ../
pg_prove tests/**/*.sql  # test
```

