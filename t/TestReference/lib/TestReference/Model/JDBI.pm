package TestReference::Model::JDBI;

use strict;
use warnings;
use base qw( Catalyst::Model::Jifty::DBI );

__PACKAGE__->config(
  schema_base  => 'TestReference::Schema',
  connect_info => { driver => 'SQLite', database => 'testdb3' },
);

1;
