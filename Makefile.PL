use inc::Module::Install;
name 'Class-Null';
all_from 'lib/Class/Null.pm';
perl_version '5.006';

build_requires 'Test::More' => '0.70';

use_standard_tests;
auto_include;
WriteAll;
