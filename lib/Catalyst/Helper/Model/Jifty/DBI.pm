package Catalyst::Helper::Model::Jifty::DBI;

use strict;
use warnings;
use Carp;
use UNIVERSAL::require;

=head1 NAME

Catalyst::Helper::Model::Jifty::DBI- Helper for Jifty::DBI Models

=head1 SYNOPSIS

  script/create.pl model ModelName Jifty::DBI My::SchemaClass [ connect_info arguments ]

=head1 DESCRIPTION

Helper for the Jifty::DBI Models.

=head2 Arguments:

    ModelName is the short name for the Model class being generated

    My::SchemaClass is the fully qualified classname of your Schema,
      which might or might not yet exist.

    connect_info arguments are the same as what L<Jifty::DBI::Handle>
    expects. just separate it with spaces rather than commas. for 
    instance:

    driver Pg database test host reason user twit password blah

=head2 METHODS

=head3 mk_compclass

=cut

sub mk_compclass {
    my ( $self, $helper, $schema_class, %connect_info) = @_;

    $helper->{schema_class} = $schema_class
        or die "Must supply schema class name";

    if(%connect_info) {
        $helper->{setup_connect_info} = 1;
        my %helper_connect_info = %connect_info;
        for(keys %helper_connect_info) {
	    my $val=$helper_connect_info{$_};
            $helper_connect_info{$_} = qq{'$val'} if $val !~ /^\s*[[{]/;
        }
        $helper->{connect_info} = \%helper_connect_info;
    }


    my $file = $helper->{file};
    $helper->render_file( 'compclass', $file );
}

=head1 SEE ALSO

General Catalyst Stuff:

L<Catalyst::Manual>, L<Catalyst::Test>, L<Catalyst::Request>,
L<Catalyst::Response>, L<Catalyst::Helper>, L<Catalyst>,

L<Jifty::DBI>

=head1 AUTHOR

Marcus Ramberg, C<mramberg@cpan.org>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

__DATA__

=begin pod_to_ignore

__compclass__
package [% class %];

use strict;
use base 'Catalyst::Model::Jifty::DBI';

__PACKAGE__->config(
    schema => '[% schema_class %]',
    [% IF setup_connect_info %]connect_info => {
        [% FOREACH key = connect_info.keys %]
	[%key%] => [% connect_info.$key %],
        [% END %]
    },[% END %]
);

=head1 NAME

[% class %] - Catalyst Jifty::DBI Model
=head1 SYNOPSIS

See L<[% app %]>

=head1 DESCRIPTION

L<Catalyst::Model::Jifty::DBI> Model using schema L<[% schema_class %]>

=head1 AUTHOR

[% author %]

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
