#!/usr/bin/perl

use warnings;
use strict;
use Module::Build;

Module::Build->new(
    module_name       => 'Class-Null',
    dist_version_from => 'lib/Class/Null.pm',
    license           => 'perl',
)->create_build_script;
