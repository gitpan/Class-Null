#!/usr/bin/env perl

use warnings;
use strict;
use Project::Build;

Project::Build->new(
    module_name       => 'Class-Null',
    dist_version_from => 'lib/Class/Null.pm',
    dist_author       => 'Marcel Gruenauer <marcel@noug.at>',
)->create_build_script;
