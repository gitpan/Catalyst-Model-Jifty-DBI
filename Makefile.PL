use inc::Module::Install;

name 'Catalyst-Model-Jifty-DBI';
all_from 'lib/Catalyst/Model/Jifty/DBI.pm';

requires Catalyst => '5.64';
requires Jifty::DBI;

auto_install;
WriteAll;
