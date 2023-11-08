#!/usr/bin/perl
use strict;
use warnings;
use Card;
use Deck;
use Hand;
use Player;

my $file_path = $ARGV[0];

# Check if a file path is provided as a command-line argument
if (@ARGV == 1) {
    # Check if the file exists
    if (!-e $file_path) {
        die "File not found: $file_path\n";
    }
    print "***USING TEST DECK***\n";
    # Read the file and create cards
    my %card_seen;
    my @cards;
    open my $file, '<', $file_path or die "Cannot open $file_path: $!\n";
    while (my $line = <$file>) {
        chomp $line;
        next if $line eq '';  # Skip empty lines
        my $card_str = $line;

        if ($card_seen{$card_str}) {
            die "Duplicate card found in the file: $card_str\n";
        }

        $card_seen{$card_str} = 1;
        push @cards, $card_str;
    }
    close $file;

    # Display the contents of the file
    print "Contents of the file:\n";
    foreach my $card_str (@cards) {
        print "$card_str\n";
    }
    print "\n";

    # Create 6 players with 5 cards each
    my @players;
    for my $i (1..6) {
        my $player_name = "Player $i";
        my $hand = Hand->new();
        my @player_cards = splice(@cards, 0, 5);

        if (scalar @player_cards != 5) {
            die "Not enough cards for Player $i\n";
        }

        my $player = Player->new($player_name, Hand->new(@player_cards));
        push @players, $player;
    }

    # Rank and print each player's hand
    for my $player (@players) {
        my $player_name = $player->getName();
        my $player_hand = $player->getHand();

        # Print the player's hand
        print "$player_name's Hand:\n";
        $player_hand->printHand();

        # Rank and print the player's hand
        my $hand_rank = $player_hand->rankHand();
        print "$player_name's Hand Rank: $hand_rank\n";

        print "\n";
    }
} elsif (@ARGV == 0) {
    print "***USING RANDOM DECK***\n";
} else {
    die "Usage: perl program.pl [file_path]\n";
}

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
    print "$playerName Hand:";
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

