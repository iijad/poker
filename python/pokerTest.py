import sys
import os
from random import shuffle
from Cards import Cards
from Cards import Deck
from Cards import Hand
from Cards import Player
from Cards import PlayerRank

def compare_suits(suit1, suit2):
    suit_order = "DCHS"  # The order is Diamonds, Clubs, Hearts, Spades
    if suit1 is None:
        return 1  # None is considered greater than any suit
    if suit2 is None:
        return -1  # None is considered greater than any suit
    return suit_order.index(suit1) - suit_order.index(suit2)
    
# Function to read a deck from a file
def read_deck_from_file(file_path):
    all_hands = []
    try:
        with open(file_path, 'r') as reader:
            lines = reader.readlines()
            unique_cards = set()
            print("File Name: " + file_path)
            for line in lines:
                print(line.strip())
                card_records = line.strip().split(',')
                if len(card_records) != 5:
                    print("Invalid card record: " + str(card_records))
                    print(len(card_records))
                    continue
                for card_record in card_records:
                    if card_record in unique_cards:
                        print(" *** ERROR - DUPLICATE CARD FOUND IN DECK *** ")
                        print("DUPLICATE: " + card_record)
                        sys.exit(1)
                    unique_cards.add(card_record)
                if len(card_records) == 5:
                    new_hand = []
                    for card_str in card_records:
                        if len(card_str) == 2:
                            rank = card_str[0]
                            suit = card_str[1]
                        elif len(card_str) == 3:
                            rank = card_str[:2]
                            suit = card_str[2]
                        else:
                            print("Invalid card format: " + card_str)
                            continue
                        card = Cards(rank, suit)
                        new_hand.append(card)
                    all_hands.append(new_hand)
    except IOError as e:
        print("Error reading the file: " + str(e))
        sys.exit(1)

    if len(all_hands) < 5:
        print("Not enough cards to make a hand.")
    else:
        print("Here are the six hands...")
        for i in range(6):
            hand = all_hands[i]
            print("Hand " + str(i + 1) + ":")
            for card in hand:
                print(str(card), "\t")
            print()

if __name__ == "__main__":
    deck = Deck()
    deck.shuffle()

    if len(sys.argv) == 1:
        print("*** USING RANDOMIZED DECK OF CARDS ***")
        print()
        print()
        print("*** Shuffled 52 card deck: ")
    else:
        print("*** USING TEST DECK ***")  
        file = sys.argv[1]
        read_deck_from_file(file)
        sys.exit(0)

    num_players = 6
    cards_per_hand = 5
    new_hand = Hand()
    deck.print_deck()

    # Creating and dealing hands to players
    players = [Player("Player " + str(i + 1)) for i in range(num_players)]

    # Making a list to store objects of the class PlayerRank
    player_ranks = []

    for i in range(cards_per_hand):
        for player in players:
            new_card = deck.deal_card()
            if new_card is not None:
                player.add_to_hand(new_card)
            else:
                print("The deck is empty.")
                break

    player_ranks.sort()

    # Calculating and storing ranks for each player's hand
    print("Here are the six hands... ")
    for new_player in players:
        print(new_player.get_name() + " 's Hand:")
        new_player.get_hand().print_hand()
        hand_ranks = new_player.get_hand().rank_hand()
        flush_suit = new_player.get_hand().get_flush_suit()
        print()
        player_ranks.append(PlayerRank(new_player, hand_ranks, flush_suit))

    # Sorting players in order of first, then second, then third, etc...
    player_ranks.sort(key=lambda pr: (-Cards.get_rank_value(pr.get_rank()), compare_suits(pr.get_suit(), pr.get_suit())))

    # Printing out each hand and rank in order
    print("//////////////////////////Winning Hand Order//////////////////////////////////////////////////////")
    for new_player_rank in player_ranks:
        print(new_player_rank.get_player().get_name() + " 's Hand:")
        new_player_rank.get_player().get_hand().sort_hand()
        print(" - " + new_player_rank.get_rank())
        print()

    deck.print_remaining_deck()


