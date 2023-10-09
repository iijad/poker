using System;
using System.Collections.Generic;
using System.Linq;
public class Cards {

  
		public char Suit { get; }
    public string Rank { get; }

    // Constructor to initialize a card with a specific suit and rank
    public Cards(char suit, string rank)
    {
        Suit = suit;
        Rank = rank;
    }

    // Method to get the card's display name (e.g., "Ace of Spades")
    public string GetDisplayName()
    {
        return $"{Rank}{Suit}";
    }
    
    public int GetRankValue()
    {
        switch (Rank)
        {
            case "A":
                return 1;
            case "2":
                return 2;
            case "3":
                return 3;
            case "4":
                return 4;
            case "5":
                return 5;
            case "6":
                return 6;
            case "7":
                return 7;
            case "8":
                return 8;
            case "9":
                return 9;
            case "10":
                return 10;
            case "J":
                return 11;
            case "Q":
                return 12;
            case "K":
                return 13;
            default:
                throw new ArgumentException("Invalid card rank.");
        }
    }
    
    ////Deck Class/////
  public class Deck  {
    private List<Cards> cards;
    private Random random;
    
    public Deck()
    {
        // Initialize the deck with all 52 cards
        InitializeDeck();
    }
     // Initialize the deck with 52 cards
    private void InitializeDeck()
    {
        cards = new List<Cards>();
        random = new Random();

        char[] suits = { 'H', 'D', 'C', 'S' }; // Hearts, Diamonds, Clubs, Spades
        string[] ranks = { "Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K" };

        foreach (char suit in suits)
        {
            foreach (string rank in ranks)
            {
                cards.Add(new Cards(suit, rank));
            }
        }
    }
    
    public void Shuffle()
    {
        cards = cards.OrderBy(card => random.Next()).ToList();
    }
    
    public Cards Deal()
    {
        if (cards.Count == 0)
        {
            throw new InvalidOperationException("The deck is empty.");
        }

        Cards card = cards.First();
        cards.Remove(card);
        return card;
    }
    
    public int Size()
    {
        return cards.Count;
    }
    
    public void PrintDeck()
    {
        foreach (Cards card in cards)
        {
            Console.WriteLine(card.GetDisplayName());
        }
    }
    
    public void PrintRemainingDeck()
    {
        foreach (Cards card in cards)
        {
            Console.WriteLine(card.GetDisplayName());
        }
    }
    
    
  }
  ////Hand Class////
  public class Hand
  {
    private List<Cards> cards;
    
    public Hand()
    {
        cards = new List<Cards>();
    }

    // Add a card to the hand
    public void AddCard(Cards card)
    {
        cards.Add(card);
    }
    
    // Get the cards in the hand
    public List<Cards> GetCards()
    {
        return cards;
    }
    
    public void Sort()
    {
        cards.Sort((card1, card2) =>
        {
            if (card1.Rank == card2.Rank)
            {
                return card1.Suit.CompareTo(card2.Suit);
            }
            return card1.Rank.CompareTo(card2.Rank);
        });
    }
    
    public int CompareTo(Hand otherHand)
    {
        this.Sort();
        otherHand.Sort();

        // Compare each card in the hands
        for (int i = 0; i < Math.Min(cards.Count, otherHand.cards.Count); i++)
        {
            int compareResult = cards[i].Rank.CompareTo(otherHand.cards[i].Rank);
            if (compareResult != 0)
            {
                return compareResult;
            }
        }
         return cards.Count.CompareTo(otherHand.cards.Count);
    }
    
    // Print the cards in the hand
    public void PrintHand()
    {
        foreach (Cards card in cards)
        {
            Console.WriteLine(card.GetDisplayName());
        }
    }
    
    public string RankHand()
    {
    if (IsRoyalFlush())
    {
        return "Royal Flush";
    }
    if (IsStraightFlush())
    {
        return "Straight Flush";
    }
    if (IsFourOfAKind())
    {
        return "Four of a Kind";
    }
    if (IsFullHouse())
    {
      return "Full House";
    }
    if (IsFlush())
    {
        return "Flush";
    }
    if (IsStraight())
    {
        return "Straight";
    }
    if (IsThreeOfAKind())
    {
        return "Three of a Kind";
    }
    if (IsTwoPair())
    {
        return "Two Pair";
    }
    if (IsPair())
    {
        return "Pair";
    }

    return "High Card";
}
// Check for a Royal Flush
private bool IsRoyalFlush()
{
    if (IsStraightFlush() && cards.Any(card => card.Rank == "A"))
    {
        return true;
    }
    return false;
}

// Check for a Straight Flush
private bool IsStraightFlush()
{
    if (IsFlush() && IsStraight())
    {
        return true;
    }
    return false;
}

// Check for Four of a Kind
private bool IsFourOfAKind()
{
    var groupedCards = cards.GroupBy(card => card.Rank);
    return groupedCards.Any(group => group.Count() == 4);
}

// Check for a Full House
private bool IsFullHouse()
{
    var groupedCards = cards.GroupBy(card => card.Rank);
    return groupedCards.Any(group => group.Count() == 3) &&
           groupedCards.Any(group => group.Count() == 2);
}

// Check for a Flush
private bool IsFlush()
{
    return cards.All(card => card.Suit == cards.First().Suit);
}

// Check for a Straight
private bool IsStraight()
{
    var sortedCards = cards.OrderBy(card => card.GetRankValue()).ToList();
    for (int i = 0; i < sortedCards.Count - 1; i++)
    {
        if (sortedCards[i + 1].GetRankValue() - sortedCards[i].GetRankValue() != 1)
        {
            return false;
        }
    }
    return true;
}

// Check for Three of a Kind
private bool IsThreeOfAKind()
{
    var groupedCards = cards.GroupBy(card => card.Rank);
    return groupedCards.Any(group => group.Count() == 3);
}

// Check for Two Pair
private bool IsTwoPair()
{
    var groupedCards = cards.GroupBy(card => card.Rank);
    return groupedCards.Count(group => group.Count() == 2) == 2;
}

// Check for a Pair
private bool IsPair()
{
    var groupedCards = cards.GroupBy(card => card.Rank);
    return groupedCards.Any(group => group.Count() == 2);
}
}

///Player Class/////

public class Player
{
    public string Name { get; }
    private List<Cards> hand;

    public Player(string name)
    {
        Name = name;
        hand = new List<Cards>();
    }

    // Add a card to the player's hand
    public void AddCardToHand(Cards card)
    {
        hand.Add(card);
    }

    // Get the cards in the player's hand
    public List<Cards> GetHand()
    {
        return hand;
    }

    // Clear the player's hand
    public void ClearHand()
    {
        hand.Clear();
    }

    // Print the cards in the player's hand
    public void PrintHand()
    {
        Console.WriteLine($"{Name}'s Hand:");
        foreach (Cards card in hand)
        {
            Console.WriteLine(card.GetDisplayName());
        }
    }
}

///PlayerRank/////
public class PlayerRank
{
    public string PlayerName { get; }
    public string HandRank { get; }
    private List<Cards> hand;

    public PlayerRank(string playerName, string handRank, List<Cards> playerHand)
    {
        PlayerName = playerName;
        HandRank = handRank;
        hand = playerHand;
    }
    
    // Compare the hand rank with another player's hand rank
    public int CompareTo(PlayerRank otherPlayer)
    {
        return string.Compare(HandRank, otherPlayer.HandRank, StringComparison.Ordinal);
    }

    // Get the suit of a specific card in the hand
    public char GetCardSuit(int cardIndex)
    {
        if (cardIndex >= 0 && cardIndex < hand.Count)
        {
            return hand[cardIndex].Suit;
        }
        throw new IndexOutOfRangeException("Invalid card index.");
    }
}
    

      
}
