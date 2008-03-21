use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Catalyst::Model::Jifty::DBI',
    AUTHOR        => 'Kenichi Ishigaki <ishigaki@cpan.org>',
    VERSION_FROM  => 'lib/Catalyst/Model/Jifty/DBI.pm',
    ABSTRACT_FROM => 'lib/Catalyst/Model/Jifty/DBI.pm',
    PREREQ_PM => {
        'Catalyst::Runtime'     => 0,
        'Class::Accessor::Fast' => 0,
        'File::Spec'            => 0,
        'File::Basename'        => 0,
        'Jifty::DBI'            => 0.47,
        'Module::Find'          => 0,
        'NEXT'                  => 0,
        'Test::UseAllModules'   => 0.09,
        'UNIVERSAL::require'    => 0.11,
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.31
        ? ( LICENSE => 'perl' )
        : ()
    ),
);
