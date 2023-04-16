#!/usr/bin/perl
#
#    lsmft.pl
#
#        Simple tool to help users play with their food. 
#

use strict;
use warnings;

use Text::CSV qw( csv );
use LWP::Simple;


sub usage() {
    
    my $alen = @ARGV;

    if ( $alen != 0 ) 
    {
        print "usage: lsmft.pl\n";
        print "Exiting...\n";

        exit;
    }
}


sub list_mexican_food_trucks
{
    my ( $csv_name, $csv_fh, $site ) = @_;

    my $text = get $site;
    print $csv_fh  $text;

    my $aoh = csv (in => $csv_name, headers => "auto");   # as array of hash
    
    print "\n\n            List Mexican Food Trucks (LSMFT) \n";

    print "\n  -------------------------------------------------\n\n";

    foreach my $hash (@$aoh)
    {
        my $food_list = $hash->{'FoodItems'};

        if ( $food_list and index ( $food_list, "Taco" ) != -1)
        {
            print "    Business Name:    $hash->{'Applicant'} \n";
            print "    Food Items:       $hash->{'FoodItems'} \n";
            print "    General Location: $hash->{'LocationDescription'} \n\n";
            print "  -------------------------------------------------\n\n";
        }
    }
}


#     main  entrypoint
{

    usage;

    my $site       = "https://data.sfgov.org/api/views/rqzj-sfat/rows.csv";

    my $name       = "food_trucks";
    my $csv_name   = "./$name.csv";

    open my $csv_fh, '+>', $csv_name or die;

    list_mexican_food_trucks($csv_name, $csv_fh, $site);

   close($csv_fh);
   unlink($csv_name);
}
