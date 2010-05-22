
use strict;
use warnings;

 BEGIN { require 5.008; } 

use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Class::Null',
                       'DISTNAME' => 'Class-Null',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.31'
                                               },
                       'AUTHOR' => 'Marcel Gruenauer <marcel@cpan.org>',
                       'BUILD_REQUIRES' => {
                                             'Test::More' => '0.94',
                                             'Scalar::Util' => '0',
                                             'parent' => '0',
                                             'English' => '0',
                                             'File::Find' => '0',
                                             'File::Temp' => '0',
                                             'Carp' => '0'
                                           },
                       'ABSTRACT' => 'Implements the Null Class design pattern',
                       'EXE_FILES' => [],
                       'VERSION' => '2.101420',
                       'PREREQ_PM' => {
                                        'overload' => '0'
                                      },
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{BUILD_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.56) };

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



