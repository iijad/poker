#!/usr/bin/perl
package Deck;

use Card;
use List::Util qw(shuffle);

#Constructor
sub new {
    my $class = shift;
    my @deck;
    
    my @suits = ("S", "H", "D", "C");
    my @ranks = ("2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A");
    
    foreach my $suit (@suits) {
        foreach my $rank (@ranks) {
            my $card = Card->new($rank, $suit);
            push @deck, $card;
        }
    }
    
    my $self = {
        cards => \@deck,
    };
    
    bless $self, $class;
    return $self;
}

#shuffling the deck
sub shuffleDeck {
    my $self = shift;
    $self-> {cards} =  [shuffle @{$self->{cards}}];
}

#printing the deck, with 13 cards per line
sub printDeck {
    my $self = shift;
    my $cards = $self->{cards};
    for (my $i = 0; $i < scalar(@$cards); $i++) {
        print $cards->[$i]->toString() . "\t";
        if (($i + 1) % 13 == 0) {
            print "\n"
        }
    }
}

#dealing cards
sub dealCards {
    my $self = shift;
    my $numCards = shift;
    my @dealtCards;
    
    if ($numCards > 0 && $numCards <= scalar(@{self->{cards}})) {
        push @dealtCards, splice(@{$self->{cards}}, 0, $numCards);
    }
    
    return @dealtCards;
}

#printing the ramiander of the deck
sub printRemainingDeck {
    my $self = shift;
    my $cards = $self->{cards};
    for (my $i=0; $i < scalar(@$cards); $i++) {
        print $cards->[$i]->toString() . "\t";
        if (($i + 1) % 13 == 0) {
            print "\n";
        }
    }
} 

1; #End of DECK CLASS
