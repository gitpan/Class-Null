use inc::Module::Install;
name 'Class-Null';
all_from 'lib/Class/Null.pm';

build_requires 'Test::More';

use_test_base;
auto_include;
WriteAll;
