package TestApp::Controller::Multi;

use strict;
use warnings;
use base qw( Catalyst::Controller );

sub setup : Local {
  my ( $self, $c ) = @_;

  $c->forward('cleanup', 1);  # remove previous database if any

  foreach my $name ( $c->model('JDBI_M')->databases ) {
    $c->model('JDBI_M')->setup_database( name => $name );
  }

  # insert default data
  my $book1 = $c->model('JDBI_M')->record('Book', name => 'db1' );
     $book1->create(
       name => 'Perl Best Practices',
       isbn => '0-596-00173-8',
     );
     $book1->create(
       name => 'Perl Hacks',
       isbn => '0-596-52674-1',
     );

  my $author1 = $c->model('JDBI_M')->record('Author', name => 'db1' );
     $author1->create(
       name    => 'Damian Conway',
       pauseid => 'DCONWAY',
     );
     $author1->create(
       name    => 'chromatic',
       pauseid => 'CHROMATIC',
     );

  my $book2 = $c->model('JDBI_M')->record('Book', name => 'db2' );
     $book2->create(
       name => 'Catalyst',
       isbn => '1-84719-095-2',
     );
     $book2->create(
       name => 'Higher Order Perl',
       isbn => '1-55860-701-3',
     );

  my $author2 = $c->model('JDBI_M')->record('Author', name => 'db2' );
     $author2->create(
       name    => 'Jonathan Rockway',
       pauseid => 'JROCKWAY',
     );
     $author2->create(
       name    => 'Mark Jason Dominus',
       pauseid => 'MJD',
     );

  $c->response->body( 1 );
}

sub cleanup : Local {
  my ( $self, $c, $no_return ) = @_;

  foreach my $name ( $c->model('JDBI_M')->databases ) {
    my $testdb = $c->model('JDBI_M')->database( name => $name );

    return unless -e $testdb;

    # to avoid Permission issue on some platforms
    $c->model('JDBI_M')->disconnect( name => $name );

    unlink $testdb or die "Can't remove previous database: $!";
  }

  unless ( $no_return ) {
    $c->response->body( 1 );
  }
}

sub book : Local {
  my ( $self, $c ) = @_;

  my $book = $c->model('JDBI_M::Book');
     $book->load(1);
  if ( $book->id ) {
    $c->response->body( $book->id );
  }
  else {
    $c->response->body( 0 );
  }
}

sub book_collection : Local {
  my ( $self, $c ) = @_;

  my $books = $c->model('JDBI_M::BookCollection');
     $books->unlimit;
  if ( $books->first ) {
    $c->response->body( $books->first->name );
  }
  else {
    $c->response->body( 0 );
  }
}

sub author : Local {
  my ( $self, $c ) = @_;

  my $author = $c->model('JDBI_M::Author');
     $author->load(1);
  if ( $author->id ) {
    $c->response->body( $author->pauseid );
  }
  else {
    $c->response->body( 0 );
  }
}

sub author_collection : Local {
  my ( $self, $c ) = @_;

  # This collection is provided automatically by C::M::Jifty::DBI!
  my $authors = $c->model('JDBI_M::AuthorCollection');
     $authors->unlimit;
  if ( $authors->first ) {
    $c->response->body( $authors->first->name );
  }
  else {
    $c->response->body( 0 );
  }
}

sub book_false : Local {
  my ( $self, $c ) = @_;

  my $book = $c->model('JDBI_M::Book');
     $book->load_by_cols( name => 'my book');
  if ( $book->id ) {
    $c->response->body( 0 );  # shouldn't be found
  }
  else {
    $c->response->body( 1 );
  }
}

sub book_collection_false : Local {
  my ( $self, $c ) = @_;

  my $books = $c->model('JDBI_M::BookCollection');
     $books->limit( column => 'name', value => 'my book' );
  if ( $books->first ) {
    $c->response->body( 0 ); # shouldn't be found
  }
  else {
    $c->response->body( 1 );
  }
}

sub author_false : Local {
  my ( $self, $c ) = @_;

  my $author = $c->model('JDBI_M::Author');
     $author->load_by_cols( name => 'nowhere man' );
  if ( $author->id ) {
    $c->response->body( 0 ); # shouldn't be found
  }
  else {
    $c->response->body( 1 );
  }
}

sub author_collection_false : Local {
  my ( $self, $c ) = @_;

  # This collection is provided automatically by C::M::Jifty::DBI!
  my $authors = $c->model('JDBI_M::AuthorCollection');
     $authors->limit( column => 'pauseid', value => 'FOOBAR' );
  if ( $authors->first ) {
    $c->response->body( 0 ); # shouldn't be found
  }
  else {
    $c->response->body( 1 );
  }
}

# db1

sub book_db1 : Local {
  my ( $self, $c ) = @_;

  my $book = $c->model('JDBI_M')->record('Book', name => 'db1');
     $book->load(1);
  if ( $book->id ) {
    $c->response->body( $book->id );
  }
  else {
    $c->response->body( 0 );
  }
}

sub book_collection_db1 : Local {
  my ( $self, $c ) = @_;

  my $books = $c->model('JDBI_M')->collection('BookCollection', name => 'db1');
     $books->unlimit;
  if ( $books->first ) {
    $c->response->body( $books->first->name );
  }
  else {
    $c->response->body( 0 );
  }
}

sub author_db1 : Local {
  my ( $self, $c ) = @_;

  my $author = $c->model('JDBI_M')->record('Author', name => 'db1');
     $author->load(1);
  if ( $author->id ) {
    $c->response->body( $author->pauseid );
  }
  else {
    $c->response->body( 0 );
  }
}

sub author_collection_db1 : Local {
  my ( $self, $c ) = @_;

  # This collection is provided automatically by C::M::Jifty::DBI!
  my $authors = $c->model('JDBI_M')->collection('AuthorCollection', name => 'db1');
     $authors->unlimit;
  if ( $authors->first ) {
    $c->response->body( $authors->first->name );
  }
  else {
    $c->response->body( 0 );
  }
}

sub book_false_db1 : Local {
  my ( $self, $c ) = @_;

  my $book = $c->model('JDBI_M')->record('Book', name => 'db1');
     $book->load_by_cols( name => 'my book');
  if ( $book->id ) {
    $c->response->body( 0 );  # shouldn't be found
  }
  else {
    $c->response->body( 1 );
  }
}

sub book_collection_false_db1 : Local {
  my ( $self, $c ) = @_;

  my $books = $c->model('JDBI_M')->collection('BookCollection', name => 'db1');
     $books->limit( column => 'name', value => 'my book' );
  if ( $books->first ) {
    $c->response->body( 0 ); # shouldn't be found
  }
  else {
    $c->response->body( 1 );
  }
}

sub author_false_db1 : Local {
  my ( $self, $c ) = @_;

  my $author = $c->model('JDBI_M')->record('Author', name => 'db1');
     $author->load_by_cols( name => 'nowhere man' );
  if ( $author->id ) {
    $c->response->body( 0 ); # shouldn't be found
  }
  else {
    $c->response->body( 1 );
  }
}

sub author_collection_false_db1 : Local {
  my ( $self, $c ) = @_;

  # This collection is provided automatically by C::M::Jifty::DBI!
  my $authors = $c->model('JDBI_M')->collection('AuthorCollection', name => 'db1');
     $authors->limit( column => 'pauseid', value => 'FOOBAR' );
  if ( $authors->first ) {
    $c->response->body( 0 ); # shouldn't be found
  }
  else {
    $c->response->body( 1 );
  }
}

# db2

sub book_db2 : Local {
  my ( $self, $c ) = @_;

  my $book = $c->model('JDBI_M')->record('Book', name => 'db2');
     $book->load(1);
  if ( $book->id ) {
    $c->response->body( $book->id );
  }
  else {
    $c->response->body( 0 );
  }
}

sub book_collection_db2 : Local {
  my ( $self, $c ) = @_;

  my $books = $c->model('JDBI_M')->collection('BookCollection', name => 'db2');
     $books->unlimit;
  if ( $books->first ) {
    $c->response->body( $books->first->name );
  }
  else {
    $c->response->body( 0 );
  }
}

sub author_db2 : Local {
  my ( $self, $c ) = @_;

  my $author = $c->model('JDBI_M')->record('Author', name => 'db2');
     $author->load(1);
  if ( $author->id ) {
    $c->response->body( $author->pauseid );
  }
  else {
    $c->response->body( 0 );
  }
}

sub author_collection_db2 : Local {
  my ( $self, $c ) = @_;

  # This collection is provided automatically by C::M::Jifty::DBI!
  my $authors = $c->model('JDBI_M')->collection('AuthorCollection', name => 'db2');
     $authors->unlimit;
  if ( $authors->first ) {
    $c->response->body( $authors->first->name );
  }
  else {
    $c->response->body( 0 );
  }
}

sub book_false_db2 : Local {
  my ( $self, $c ) = @_;

  my $book = $c->model('JDBI_M')->record('Book', name => 'db2');
     $book->load_by_cols( name => 'my book');
  if ( $book->id ) {
    $c->response->body( 0 );  # shouldn't be found
  }
  else {
    $c->response->body( 1 );
  }
}

sub book_collection_false_db2 : Local {
  my ( $self, $c ) = @_;

  my $books = $c->model('JDBI_M')->collection('BookCollection', name => 'db2');
     $books->limit( column => 'name', value => 'my book' );
  if ( $books->first ) {
    $c->response->body( 0 ); # shouldn't be found
  }
  else {
    $c->response->body( 1 );
  }
}

sub author_false_db2 : Local {
  my ( $self, $c ) = @_;

  my $author = $c->model('JDBI_M')->record('Author', name => 'db2');
     $author->load_by_cols( name => 'nowhere man' );
  if ( $author->id ) {
    $c->response->body( 0 ); # shouldn't be found
  }
  else {
    $c->response->body( 1 );
  }
}

sub author_collection_false_db2 : Local {
  my ( $self, $c ) = @_;

  # This collection is provided automatically by C::M::Jifty::DBI!
  my $authors = $c->model('JDBI_M')->collection('AuthorCollection', name => 'db2');
     $authors->limit( column => 'pauseid', value => 'FOOBAR' );
  if ( $authors->first ) {
    $c->response->body( 0 ); # shouldn't be found
  }
  else {
    $c->response->body( 1 );
  }
}

1;
