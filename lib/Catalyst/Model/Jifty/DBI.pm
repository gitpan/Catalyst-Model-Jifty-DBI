package Catalyst::Model::Jifty::DBI;

use base 'Catalyst::Model';

use strict; 
use warnings;

use Carp qw/croak/;
use Jifty::DBI::Handle;

our $VERSION = '0.01';

__PACKAGE__->mk_accessors(qw/handle/);


sub new {
    my $self  = shift->NEXT::new(@_);
    my $class = ref $self;
    my $model_name = $class;
    $model_name =~ s/^[\w:]+::(?:Model|M):://;
    croak 'Catalyst::Model::Jifty::DBI needs a db config. Set db config '.
    'as a hashref like the Jifty::DBI::Handle constructor takes' 
        unless ref $self->config->{connect_info} eq 'HASH';
    $self->handle(Jifty::DBI::Handle->new());
    $self->handle->connect( %{ $self->config->{connect_info} } );
    if ( ref $self->config->{records} eq 'ARRAY') {
	no strict 'refs';
	foreach my $moniker ( @{ $self->config->{records} } ) {
	    my $classname = "${class}::$moniker";
	    *{"${classname}::ACCEPT_CONTEXT"} = sub {
		shift;
		shift->model($model_name)->record($moniker);
	    }


	}
    } 
    elsif ( defined $self->config->{records} ) {
	croak('Classes must be specified as an arrayref');
    } 
    return $self;
}

sub record {
    my ($self,$class) = @_;
    my $composed_class = $self->config->{schema}.'::'.$class;
    $composed_class->require || croak "Could not load $composed_class: $@";
    return $composed_class->new(handle=>$self->handle);
}

1;

=head1 NAME 

Catalyst::Model::Jifty::DBI - A Catalyst interface to the Jifty db layer

=head1 SYNOPSIS

  $c->model('Jifty')->class('User')->load_by_cols(id=>1);
  # or if you specify config->{records} as an arrayref of names
  $c->model('Jifty::User')->load_by_cols(id=>1);

=head1 DESCRIPTION

This is a simple interface to the L<Jifty::DBI> module. It's a 
convenient way to use it from your Catalyst Application.

=head1 CONFIG

=head2 schema_base

The namespace to look for record definitions in. the record method uses
this to find your module.

=head2 db

This should be a hashref taking connection parameters. See the 
L<Jifty::DBI::Handle> documentation for more information about the 
parameters it takes.

=head1 METHODS

=head2 new

Constructor. Sets up your Catalyst Model class and creates the handle.

=head2 record 

Accessor to get a handle on your jifty record. Takes a record name, and
creates a new instance of it based on the schema_base and the handle.

=head2 handle

This represents your L<Jifty::DBI::Handle> instance. You can use it
directly, or get it passed to your jifty record by using the C<class>
method.

=head1 SEE ALSO

L<Catalyst>

L<Catalyst::Model>

L<Jifty::DBI>

=head1 AUTHOR

Marcus Ramberg, <mramberg@cpan.org>

=head1 LICENSE

This program is free software, you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut


