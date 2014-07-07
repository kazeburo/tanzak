use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Tanzak',
    VERSION_FROM  => 'lib/Tanzak.pm',
    PREREQ_PM     => {
        'Kossy' =>  '0.38',
    },
    MIN_PERL_VERSION => '5.008001'
);

