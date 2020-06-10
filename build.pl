#!/usr/bin/env perl
use warnings; 

use Text::CSV_XS;
use MaxMind::DB::Writer::Tree;

# define type of metadata here
my %types = (
	autonomous_system_number => 'utf8_string',
	autonomous_system_organization => 'utf8_string',
);

# initialize new tree
my $tree = MaxMind::DB::Writer::Tree->new(
	ip_version            => 4,
	record_size           => 32,
	database_type         => 'My-IP-Data',
	languages             => ['en'],
	description =>
        { en => 'My database of IP data', fr => "Mon Data d'IP", },
	map_key_type_callback => sub { $types{ $_[0] } },
);

# open csv file containing networks, autonomous_system_number, autonomous_system_organization
open(my $fh, "<", "sampleipv4.csv") or die "zzz";

my $csv = Text::CSV_XS->new();
$csv->column_names($csv->getline($fh));
while (my $row = $csv->getline($fh)) {
    # loop over each row and insert node to tree
    $tree->insert_network(
        $row->[0],
        { 
            autonomous_system_number => $row->[1], 
            autonomous_system_organization => $row->[2], 
        },
    );
}
close $fh;

# example if you want to insert node 1 by 1
# $tree->insert_network(
#     "1.0.4.0/22",
#     { 
#         autonomous_system_number => "test", 
#         autonomous_system_organization => "test", 
#     },
# );

# write tree into file .mmdb
open my $fo, '>:raw', 'my-ip-data.mmdb';
$tree->write_tree($fo);