#!/usr/bin/perl
package Player;
use Hand;

#Constructor 
sub new { 
    my $class = shift;
    my $name = shift;
    my $hand = shift;
    
    my $self = {
        name => $name,
        hand => $hand,
    };
    
    bless $self, $class;
    return $self;
    
}

#Adding a card to a player's hand
sub addCardToHand {
    my $self = shift;
    my $card = shift;
    $self->{hand}->addCard($card);
}

#Getting the name of the player
sub getName {
    my $self = shift;
    return $self->{name};
}

#Getting the hand of the player
sub getHand {
    my $self = shift;
    return $self->{hand};
}

sub toString {
    my $self = shift;
    return $self->{name};
}


1;
