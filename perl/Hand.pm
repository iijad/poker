#!/usr/bin/perl
package Hand;
use Card;

#Constructor
sub new {
    my $class = shift;
    my @cards = @_;
    
    my $self = {
        cards=> \@cards,
    };
    
    bless $self, $class;
    return $self;
}


#Adding a card to the hand
sub addCard {
    my $self = shift;
    my $card = shift;
    push @{$self->{cards}}, $card;
}

#returning the cards in each hand
sub getCards {
    my $self = shift;
    return @{$self->{cards}};
}

#Sorting the hands
sub sortHand {
    my $self = shift;
    @{$self->{cards}} = sort { $a->getRankValue() <=> $b->getRankValue() } @{$self->{cards}};
}

# Comparing Hands
sub compareHand {
    my $self = shift;
    my $otherHand = shift;
    
    my @selfCards = $self->getCards();
    my @otherCards = $otherHand->getCards();
    
    for my $i (0 .. $#selfCards) {
        my $comparison = $selfCards[$i] -> compareCard($otherCards[$i]);
        if ($comparison != 0) {
            return $comparison;
        }
    }
    
    return 0; #Hands are equal
}

sub printHand {
    my $self = shift;
    my @cards = $self->getCards();
    
    for my $i (0 .. $#cards) {
        print $cards[$i]->toString() . "\t";
        if (($i + 1) % 5 == 0) {
            print "\n";
        }
    }
    print "\n";
}

# string representation of hand
sub toString {
    my $self = shift;
    my @cards = $self->getCards();
    my $handString = ' ';
    
    for my $i (0 .. $#cards) {
        $handString .= $cards[$i]->toString() . "\t";
        if (($i + 1) % 5 == 0) {
            $handString .= "\n";
        }
    }
    
    return $handString;
}

# ranking the hands
sub rankHand {
    my $self = shift;
    $self->sortHand();
    my @cards = $self->getCards();
    
    my %rankCount;
    my %suitCount;
    my %isStraight = 0;
    my $isFlush = 0;
    
    for my $card (@cards) { 
        my $rank = $card->getRank();
        my $suit = $card->getSuit();
        
        $rankCount{$rank}++;
        $suitCount{$suit}++;
        
        if ($rankCount{$rank} == 4) {
            return "Four of a Kind";
        } elsif ($rankCount{$rank} == 3) {
            if ($rankCount{$_} == 2) {
                return "Full House";
            }
            return "Three of a Kind";
        } elsif ($rankCount{$rank} == 2) {
            if ($rankCount{$_} == 2) {
                return "Two Pair";
            }
            return "Pair";
        }
        
        if ($suitCount{$suit} == 5) {
            $isFlush = 1;
        }
    }
    
    my @rankValues = sort { $a->getRankValue() <=> $b->getRankValue() } @cards;
    
    for my $i (0 .. $#rankValues - 1) {
        if ($rankValues[$i + 1]->getRankValue() - $rankValues[$i]->getRankValue() != 1) {
            $isStraight = 0;
            last;
        }
    }
    
    $isStraight = 1 if ($rankValues[0]->getRankValue() == 10 && $rankValues[$#rankValues]->getRankValue() == 14);
    
    if ($isFlush && $isStraight) {
        if ($rank_values[0]->getRankValue() == 10) {
            return "Royal Straight Flush";
        }
        return "Straight Flush";
    }
    
    if ($isFlush) {
        return "Flush";
    }
    
    if ($isStraight) {
        return "Straight";
    }
    
    return "High Card";
}
    

1;
    
