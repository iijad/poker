package main

import (
	"fmt"
	"math/rand"
	"sort"
	"strings"
	"time"
)

// Cards struct represents a playing card
type Cards struct {
	Suit rune
	Rank string
}

// GetDisplayName returns the card's display name (e.g., "Ace of Spades = AH")
func (c Cards) GetDisplayName() string {
	return fmt.Sprintf("%s%c", c.Rank, c.Suit)
}

// GetRankValue returns the value of the card's rank
func (c Cards) GetRankValue() int {
	rankValues := map[string]int{
		"A": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 11, "Q": 12, "K": 13,
	}
	return rankValues[c.Rank]
}

// TieBreakValue returns the tiebreaker value for the card
func (c Cards) TieBreakValue() int {
	if rankValue, err := strconv.Atoi(c.Rank); err == nil {
		return rankValue
	}

	tieBreakValues := map[string]int{"A": 14, "K": 13, "Q": 12, "J": 11}
	if value, exists := tieBreakValues[c.Rank]; exists {
		return value
	}

	panic("Invalid card rank.")
}

// CompareForTiebreaking compares two cards for tiebreaking
func (c Cards) CompareForTiebreaking(otherCard Cards) int {
	rankComparison := c.GetRankValue() - otherCard.GetRankValue()
	if rankComparison != 0 {
		return rankComparison
	}

	suitsOrder := "SHCD"
	return strings.IndexRune(suitsOrder, c.Suit) - strings.IndexRune(suitsOrder, otherCard.Suit)
}

// Deck struct represents a deck of playing cards
type Deck struct {
	cards  []Cards
	random *rand.Rand
}

// NewDeck creates a new deck of cards
func NewDeck() *Deck {
	d := &Deck{random: rand.New(rand.NewSource(time.Now().UnixNano()))}
	d.InitializeDeck()
	return d
}

// InitializeDeck initializes the deck with 52 cards
func (d *Deck) InitializeDeck() {
	suits := []rune{'H', 'D', 'C', 'S'}
	ranks := []string{"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}

	for _, suit := range suits {
		for _, rank := range ranks {
			d.cards = append(d.cards, Cards{Suit: suit, Rank: rank})
		}
	}
}

// Shuffle shuffles the deck
func (d *Deck) Shuffle() {
	sort.Slice(d.cards, func(i, j int) bool {
		return d.random.Intn(2) == 0
	})
}

// Deal deals a card from the deck
func (d *Deck) Deal() Cards {
	if len(d.cards) == 0 {
		panic("The deck is empty.")
	}

	card := d.cards[0]
	d.cards = d.cards[1:]
	return card
}

// Size returns the size of the deck
func (d *Deck) Size() int {
	return len(d.cards)
}

// PrintDeck prints the contents of the deck
func (d *Deck) PrintDeck() {
	cardsPerLine := 13
	for i, card := range d.cards {
		fmt.Printf("%-9s", card.GetDisplayName())
		if (i+1)%cardsPerLine == 0 {
			fmt.Println()
		}
	}
	fmt.Println()
}

// PrintRemainingDeck prints what's remaining in the deck
func (d *Deck) PrintRemainingDeck() {
	for _, card := range d.cards {
		fmt.Println(card.GetDisplayName())
	}
}

// Hand struct represents a hand of playing cards
type Hand struct {
	cards []Cards
}

// AddCard adds a card to the hand
func (h *Hand) AddCard(card Cards) {
	h.cards = append(h.cards, card)
}

// GetCards returns the cards in the hand
func (h *Hand) GetCards() []Cards {
	return h.cards
}

// Sort sorts the cards in the hand
func (h *Hand) Sort() {
	sort.Slice(h.cards, func(i, j int) bool {
		if h.cards[i].TieBreakValue() == h.cards[j].TieBreakValue() {
			suitsOrder := "SHCD"
			return strings.IndexRune(suitsOrder, h.cards[i].Suit) < strings.IndexRune(suitsOrder, h.cards[j].Suit)
		}
		return h.cards[i].TieBreakValue() < h.cards[j].TieBreakValue()
	})
}

// CompareTo compares two hands
func (h *Hand) CompareTo(otherHand Hand) int {
	h.Sort()
	otherHand.Sort()

	for i := 0; i < len(h.cards) && i < len(otherHand.cards); i++ {
		if compareResult := strings.Compare(h.cards[i].Rank, otherHand.cards[i].Rank); compareResult != 0 {
			return compareResult
		}
	}

	return len(h.cards) - len(otherHand.cards)
}

// PrintHand prints the cards in the hand
func (h *Hand) PrintHand() {
	cardsPerLine := 5
	for i, card := range h.cards {
		fmt.Printf("%-9s", card.GetDisplayName())
		if (i+1)%cardsPerLine == 0 {
			fmt.Println()
		}
	}
	fmt.Println()
}

// RankHand returns the rank of the hand
func (h *Hand) RankHand() string {
	if h.IsRoyalStraightFlush() {
		return "Royal Straight Flush"
	}
	if h.IsStraightFlush() {
		return "Straight Flush"
	}
	if h.IsFourOfAKind() {
		return "Four of a Kind"
	}
	if h.IsFullHouse() {
		return "Full House"
	}
	if h.IsFlush() {
		return "Flush"
	}
	if h.IsStraight() {
		return "Straight"
	}
	if h.IsThreeOfAKind() {
		return "Three of a Kind"
	}
	if h.IsTwoPair() {
		return "Two Pair"
	}
	if h.IsPair() {
		return "Pair"
	}

	return "High Card"
}

// IsRoyalStraightFlush checks for a Royal Flush
func (h *Hand) IsRoyalStraightFlush() bool {
	return h.IsStraightFlush() && h.HasRank("A")
}

// IsStraightFlush checks for a Straight Flush
func (h *Hand) IsStraightFlush() bool {
	return h.IsFlush() && h.IsStraight()
}

// IsFourOfAKind checks for Four of a Kind
func (h *Hand) IsFourOfAKind() bool {
	groupedCards := h.groupCardsByRank()
	for _, group := range groupedCards {
		if len(group) == 4 {
			return true
		}
	}
	return false
}

// IsFullHouse checks for a Full House
func (h *Hand) IsFullHouse() bool {
	groupedCards := h.groupCardsByRank()
	hasThree := false
	hasTwo := false
	for _, group := range groupedCards {
		if len(group) == 3 {
			hasThree = true
		}
		if len(group) == 2 {
			hasTwo = true
		}
	}
	return hasThree && hasTwo
}

// IsThreeOfAKind checks for Three of a Kind
func (h *Hand) IsThreeOfAKind() bool {
	groupedCards := h.groupCardsByRank()
	for _, group := range groupedCards {
		if len(group) == 3 {
			return true
		}
	}
	return false
}


// IsFlush checks for a Flush
func (h *Hand) IsFlush() bool {
	for i := 1; i < len(h.cards); i++ {
		if h.cards[i].Suit != h.cards[0].Suit {
			return false
		}
	}
	return true
}

// IsStraight checks for a Straight
func (h *Hand) IsStraight() bool {
	sortedCards := h.sortCardsByRank()
	for i := 1; i < len(sortedCards); i++ {
		if sortedCards[i].GetRankValue()-sortedCards[i-1].GetRankValue() != 1 {
			return false
		}
	}
	return true
}
// IsTwoPair checks for Two Pair
func (h *Hand) IsTwoPair() bool {
	groupedCards := h.groupCardsByRank()
	pairCount := 0
	for _, group := range groupedCards {
		if len(group) == 2 {
			pairCount++
		}
	}
	return pairCount == 2
}  

// IsPair checks for a Pair
func (h *Hand) IsPair() bool {
	groupedCards := h.groupCardsByRank()
	for _, group := range groupedCards {
		if len(group) == 2 {
			return true
		}
	}
	return false
}

// HasRank checks if the hand has a card with the specified rank
func (h *Hand) HasRank(rank string) bool {
	for _, card := range h.cards {
		if card.Rank == rank {
			return true
		}
	}
	return false
}

// groupCardsByRank groups the cards in the hand by rank
func (h *Hand) groupCardsByRank() map[string][]Cards {
	groupedCards := make(map[string][]Cards)
	for _, card := range h.cards {
		groupedCards[card.Rank] = append(groupedCards[card.Rank], card)
	}
	return groupedCards
}

// sortCardsByRank sorts the cards in the hand by rank
func (h *Hand) sortCardsByRank() []Cards {
	sortedCards := make([]Cards, len(h.cards))
	copy(sortedCards, h.cards)
	sort.Slice(sortedCards, func(i, j int) bool {
		return sortedCards[i].GetRankValue() < sortedCards[j].GetRankValue()
	})
	return sortedCards
}
