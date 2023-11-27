package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	args := os.Args[1:]

	if len(args) == 0 {
		fmt.Println("*** P O K E R   H A N D   A N A L Y S E R ***")
		fmt.Println()
		fmt.Println("***USING RANDOMIZED DECK OF CARDS***")
		fmt.Println()
		fmt.Println()
		fmt.Println("***SHUFFLED 52 CARD DECK***")
	} else {
		fmt.Println("*** P O K E R   H A N D   A N A L Y S E R ***")
		fmt.Println()
		fmt.Println("***USING TEST DECK***")

		filePath := args[0]
		allHands := readDeckFromFile(filePath)

		if len(allHands) < 5 {
			fmt.Println("Not enough cards to make a hand.")
		} else if len(args) == 1 {
			fmt.Println("Here are the six hands...")
			for i := 0; i < 6; i++ {
				hand := allHands[i]
				cardsPrinted := 0
				for _, card := range hand {
					fmt.Print(card.GetDisplayName(), "\t")
					cardsPrinted++
					if cardsPrinted >= 5 {
						fmt.Println()
						cardsPrinted = 0
					}
				}
				fmt.Println()
			}
			os.Exit(0)
		}
	}

	deck := NewDeck()
	deck.Shuffle()
	deck.PrintDeck()
	fmt.Println()

	players := make([]Player, 6)
	for i := 0; i < 6; i++ {
		players[i] = Player{Name: fmt.Sprintf("Player %d", i+1)}
	}

	for i := 0; i < 5; i++ {
		for _, player := range players {
			card := deck.Deal()
			player.AddCardToHand(card)
		}
	}

	rankedPlayers := rankPlayers(players)

	fmt.Println("*** Here is what remains in the deck...")
	deck.PrintDeck()
	fmt.Println()

	fmt.Println("*** Here are the 6 hands...")
	for i := 0; i < 6; i++ {
		playerCards := players[i].GetHand()
		for j := 0; j < len(playerCards); j++ {
			fmt.Print(playerCards[j].GetDisplayName())
			if (j+1)%5 == 0 || j == len(playerCards)-1 {
				fmt.Println()
			} else {
				fmt.Print("\t")
			}
		}
	}

	fmt.Println()
	fmt.Println("--- WINNING HAND ORDER ---")
	for _, player := range rankedPlayers {
		hand := Hand{}
		playerCards := player.GetHand()
		for _, card := range playerCards {
			hand.AddCard(card)
		}
		hand.Sort()
		handRank := ""
		switch {
		case hand.IsRoyalStraightFlush():
			handRank = "Royal Straight Flush"
		case hand.IsStraightFlush():
			handRank = "Straight Flush"
		case hand.IsFourOfAKind():
			handRank = "Four Of A Kind"
		case hand.IsFullHouse():
			handRank = "Full House"
		case hand.IsFlush():
			handRank = "Flush"
		case hand.IsStraight():
			handRank = "Straight"
		case hand.IsThreeOfAKind():
			handRank = "Three of A Kind"
		case hand.IsTwoPair():
			handRank = "Two Pair"
		case hand.IsPair():
			handRank = "Pair"
		default:
			handRank = "High Card"
		}

		fmt.Println()
		hand.PrintHand()
		fmt.Printf("- %s\n\n", handRank)
	}
}

func readDeckFromFile(filePath string) [][]Cards {
	var allHands [][]Cards
	file, err := os.Open(filePath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading the file: %s\n", err)
		os.Exit(1)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	fmt.Println("File Name: " + filePath)
	for scanner.Scan() {
		line := scanner.Text()
		fmt.Println(line)
		cardRecords := strings.Split(line, ",")
		if len(cardRecords) != 5 {
			fmt.Fprintf(os.Stderr, "Invalid card record: %s\n", strings.Join(cardRecords, ","))
			continue
		}

		var newHand []Cards
		for _, cardStr := range cardRecords {
			rank := cardStr[:len(cardStr)-1]
			suit := cardStr[len(cardStr)-1]
			card := Cards{Suit: rune(suit), Rank: rank}
			newHand = append(newHand, card)
		}
		allHands = append(allHands, newHand)
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintf(os.Stderr, "Error reading the file: %s\n", err)
		os.Exit(1)
	}

	return allHands
}

func rankPlayers(players []Player) []Player {
	return sortByRank(players, func(player Player) int {
		hand := Hand{}
		playerCards := player.GetHand()
		for _, card := range playerCards {
			hand.AddCard(card)
		}
		return handRankValue(hand)
	})
}

func handRankValue(hand Hand) int {
	switch {
	case hand.IsRoyalStraightFlush():
		return 10
	case hand.IsStraightFlush():
		return 9
	case hand.IsFourOfAKind():
		return 8
	case hand.IsFullHouse():
		return 7
	case hand.IsFlush():
		return 6
	case hand.IsStraight():
		return 5
	case hand.IsThreeOfAKind():
		return 4
	case hand.IsTwoPair():
		return 3
	case hand.IsPair():
		return 2
	default:
		return 1
	}
}

func sortByRank(players []Player, rankFunc func(player Player) int) []Player {
	return sortedPlayers(players, func(p1, p2 Player) bool {
		return rankFunc(p1) > rankFunc(p2)
	})
}

func sortedPlayers(players []Player, lessFunc func(p1, p2 Player) bool) []Player {
	sorted := make([]Player, len(players))
	copy(sorted, players)
	for i := 0; i < len(sorted)-1; i++ {
		for j := i + 1; j < len(sorted); j++ {
			if lessFunc(sorted[i], sorted[j]) {
				sorted[i], sorted[j] = sorted[j], sorted[i]
			}
		}
	}
	return sorted
}
