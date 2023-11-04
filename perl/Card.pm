#!/usr/bin/perl
package Card;

use strict;
use warnings;

#Constructor
sub new {
    my $class = shift;
    my $self = {
        rank => shift,
        suit => shift,
    };
    bless $self, $class;
    return $self;
}

#Accesor Methods
sub getSuit {
    my $self = shift;
    return $self->{suit};
}

sub getRank {
    my $self = shift;
    return $self->{rank};
}

sub toString {
    my $self = shift;
    return $self->{rank} . $self->{suit};
}

#Defining and getting the rank values for each card
my %rankValues = {
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14,
};


sub getRankValue {
    my $self = shift;
    return $rankValues{ $self->{rank} };
}

#Comparing two Cards
sub compareCard {
    my $self = shift;
    my $otherCard = shift;
    
    my $selfRankValue = $self->getRankValue();
    my $otherRankValue = $otherCard-> getRankValue();
    
    if ($selfRankValue == $otherRankValue) {
        return 0;
    } elsif ($selfRankValue > $otherRankValue) {
        return 1;
    } else {
        return -1;
    }
}

1; #End of CARD CLASS

