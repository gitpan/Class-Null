use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Class::Null',
    'VERSION_FROM'	=> 'lib/Class/Null.pm',
    'PREREQ_PM'		=> {
    	Test::Distribution => 1.02,
    },
);
