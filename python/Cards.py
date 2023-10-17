from random import shuffle

# Cards Class
class Cards:
    def __init__(self, rank, suit):
        self.rank = rank
        self.suit = suit

    def get_rank(self):
        return self.rank

    def get_suit(self):
        return self.suit

    def __lt__(self, other):
        return self.rank < other.rank

    def __str__(self):
        return str(self.rank) + str(self.suit)

    @staticmethod
    def get_rank_value(rank):
        rank_values = {
            "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7,
            "8": 8, "9": 9, "10": 10, "J": 11, "Q": 12, "K": 13, "A": 14
        }
        return rank_values.get(rank, -1)


# Deck Class
class Deck:
    def __init__(self):
        self.cards = []
        suits = ['S', 'H', 'D', 'C']
        ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

        for suit in suits:
            for rank in ranks:
                self.cards.append(Cards(rank, suit))
# suffling the deck
    def shuffle(self):
        shuffle(self.cards)
# dealing each card from the deck
    def deal_card(self):
        if self.cards:
            return self.cards.pop(0)
        return None
# returning the size of the deck
    def size(self):
        return len(self.cards)
# printing the deck
    def print_deck(self):
        count = 0
        line = []
        for card in self.cards:
            print(card, "\t")
            count += 1
            if count % 13 == 0:
                print()
# after getting the hands, printing what is remianing of the deck
    def print_remaining_deck(self):
        print("\nRemaining Cards in Deck:\t", "")
        for card in self.cards:
            print(card, "\t")
        print()


# Hand Class
class Hand:
    def __init__(self):
        self.cards = []
# adding a card to each hand
    def add_card(self, card):
        self.cards.append(card)
# getting the cards for each hand
    def get_cards(self):
        return self.cards
# sorting the hand in order of suit
    def sort_hand(self):
        self.cards.sort(key=lambda card: card.get_suit())

    def __lt__(self, other):
        return self.rank_hand() < other.rank_hand()
# printing each hand
    def print_hand(self):
        count = 0
        for card in self.cards:
            print(card, "\t")
            count += 1
            if count % 5 == 0:
                print()

    def __str__(self):
        hand_string = ""
        count = 0
        for card in self.cards:
            hand_string += str(card) + "\t"
            count += 1
            if count % 5 == 0:
                hand_string += "\n"
        return hand_string
# getting the ranks according to the rules of 5 card stud
    def rank_hand(self):
        suit_counts = {}
        rank_counts = {}
        hand_rank = "Royal Straight Flush"

        for card in self.cards:
            suit = card.get_suit()
            rank = card.get_rank()
            suit_counts[suit] = suit_counts.get(suit, 0) + 1
            rank_counts[rank] = rank_counts.get(rank, 0) + 1

        if len(suit_counts) == 1 and len(rank_counts) == 5:
            if self.is_royal_straight_flush(rank_counts.keys(), next(iter(suit_counts))):
                return "Royal Straight Flush"
            return "Straight Flush"

        if len(suit_counts) == 1 and len(rank_counts) == 5:
            if self.is_straight(rank_counts.keys()):
                return "Straight Flush"
            return "Flush"

        if 4 in rank_counts.values():
            return "Four of a Kind"

        if 3 in rank_counts.values() and 2 in rank_counts.values():
            return "Full House"

        if len(rank_counts) == 5 and self.is_straight(rank_counts.keys()):
            return "Straight"

        if 3 in rank_counts.values():
            return "Three of a Kind"

        if 2 in rank_counts.values():
            pair_count = sum(1 for count in rank_counts.values() if count == 2)
            if pair_count == 2:
                return "Two Pair"
            else:
                return "Pair"

        return "High Card"

    def is_royal_straight_flush(self, ranks, suit):
        return all(rank in ranks for rank in ["10", "J", "Q", "K", "A"])

    def is_straight(self, ranks):
        rank_values = [Cards.get_rank_value(rank) for rank in ranks]
        rank_values.sort()
        min_rank = rank_values[0]
        max_rank = rank_values[-1]

        if max_rank - min_rank == 4 and len(ranks) == 5:
            return True

        if "A" in ranks and "2" in ranks and "3" in ranks and "4" in ranks and "5" in ranks:
            return True

        return False
        
        
    def get_flush_suit(self):
        suit_counts = {}
        for card in self.cards:
            suit = card.get_suit()
            if suit in suit_counts:
                suit_counts[suit] += 1
            else:
                suit_counts[suit] = 1

        for suit, count in suit_counts.items():
            if count >= 5:
                return suit

        return None  # No flush suit found

# Player Class
class Player:
    def __init__(self, name):
        self.name = name
        self.hand = Hand()
# adding a card to each player
    def add_to_hand(self, card):
        self.hand.add_card(card)
# getting the name of each player
    def get_name(self):
        return self.name
# getting the hand
    def get_hand(self):
        return self.hand
# returning the name
    def __str__(self):
        return self.name


# PlayerRank Class
class PlayerRank:
    def __init__(self, player, rank, suit):
        self.player = player
        self.rank = rank
        self.suit = suit
# returning the player
    def get_player(self):
        return self.player
# getting the rank
    def get_rank(self):
        return self.rank
# comparing each rank
    def __lt__(self, other):
        return self.rank < other.rank

    def get_suit(self):
        return self.suit
