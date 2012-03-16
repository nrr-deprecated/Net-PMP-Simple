use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Net::PMP::Simple',
    license             => 'perl',
    dist_author         => q{Nathaniel R Reindl <nrr@corvidae.org>},
    dist_version_from   => 'lib/Net/PMP/Simple.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl' => 5.006,
    },
    add_to_cleanup      => [ 'Net-PMP-Simple-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
