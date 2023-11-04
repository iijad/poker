#!/usr/bin/perl
use strict;
use warnings;
use Card;
use Deck;
use Hand;
use Player;



#testing the card deck
my $deck = Deck->new();

$deck->shuffleDeck();

print "***Here is the Shuffled Deck...\n";
$deck->printDeck();
print "\n";

#Creating 6 players
my @players;

for my $i (1..6) {
    my $playerName = "Player $i";
    my $hand = Hand->new();
    my $player = Player->new($playerName, $hand);
    push @players, $player;
}

#Dealing 5 cards to each player
for my $player (@players) {
    my @dealtCards = $deck->dealCards(5);
    for my $card (@dealtCards) { 
        $player->addCardToHand($card);
    }
}

#Printing each hand
for my $player (@players) {
    my $playerName = $player->getName();
    my $playerHand = $player->getHand();
    #print "$playerName's Hand:";
    $playerHand->printHand();
    print "\n";
}

#Printing the remainder of the deck
print "Remaining Deck:\n";
$deck->printRemainingDeck();
print "\n";

for my $player (@players) {
    my $playerName = $player->getName();
    my $playerHand = $player->getHand();
    my $handRank = $playerHand->rankHand();
    print "playerName's Hand Rank: $handRank\n";
}

# testing the rankHand method
my $card1 = Card->new("10", "H");
my $card2 = Card->new("10", "S");
my $card3 = Card->new("10", "C");
my $card4 = Card->new("10", "D");
my $card5 = Card->new("A", "H");
my $hand = Hand->new($card1, $card2, $card3, $card4, $card5);

# Rank the hand
my $handRank = $hand->rankHand();
print "Hand Rank: $handRank\n";






print "\n*** Here is what remains in the deck...:\n";
$deck->printRemainingDeck();

