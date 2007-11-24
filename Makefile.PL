use inc::Module::Install;
include 'Module::AutoInstall';

name 'Class-Null';
all_from 'lib/Class/Null.pm';
perl_version '5.006';

build_requires 'Test::More' => '0.70';

process_templates(
    first_year => 2005,
    rest_from  => "$ENV{HOME}/.mitlib/standard_pod",
    start_tag  => '{%',
    end_tag    => '%}',
);

use_standard_tests;
auto_install;
auto_include;
WriteAll;
