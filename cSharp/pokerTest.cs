using System;
using System.Collections.Generic;
using System.Linq;

class pokerTest
{
	 public static void Main( String[] args)
	{
		Deck deck = new Deck();
    deck.Shuffle();
    Console.WriteLine("Shuffled Deck:");
    deck.PrintDeck();
    Console.WriteLine();
    
    
    Player[] players = new Player[6];
        for (int i = 0; i < 6; i++)
        {
            players[i] = new Player($"Player {i + 1}");
        }
        
    // Deal hands to the players
        for (int i = 0; i < 5; i++)
        {
            foreach (Player player in players)
            {
                Cards card = deck.Deal();
                player.AddCardToHand(card);
            }
        }
        
        // Rank the hands of the players and sort them by rank
         List<Player> rankedPlayers = players
            .Select(player =>
            {
                Hand hand = new Hand();
                List<Cards> playerCards = player.GetHand();
                foreach (Cards card in playerCards)
                {
                    hand.AddCard(card);
                }
                return new { Player = player, Hand = hand };
            })
            .OrderByDescending(item =>
            {
                if (item.Hand.IsRoyalStraightFlush()) return 10;
                if (item.Hand.IsStraightFlush()) return 9;
                if (item.Hand.IsFourOfAKind()) return 8;
                if (item.Hand.IsFullHouse()) return 7;
                if (item.Hand.IsFlush()) return 6;
                if (item.Hand.IsStraight()) return 5;
                if (item.Hand.IsThreeOfAKind()) return 4;
                if (item.Hand.IsTwoPair()) return 3;
                if (item.Hand.IsPair()) return 2;
                return 1; // High Card
            })
            .Select(item => item.Player)
            .ToList();
     // Print the remaining cards in the deck
     Console.WriteLine("Remaining Cards in the Deck:");
     deck.PrintDeck();
     Console.WriteLine();
     
      // Print the hands of the players
        for (int i = 0; i < 6; i++)
        {
            List<Cards> playerCards = players[i].GetHand();
            Console.WriteLine($"{players[i].Name}'s Hand:");
            foreach (Cards card in playerCards)
            {
                Console.WriteLine(card.GetDisplayName());
            }
            Console.WriteLine();
        }
        
        
        
       foreach (Player player in rankedPlayers)
        {
            Hand hand = new Hand();
            List<Cards> playerCards = player.GetHand();
            foreach (Cards card in playerCards)
            {
                hand.AddCard(card);
            }
        hand.Sort();
        string handRank = "";
            if (hand.IsRoyalStraightFlush()) handRank = "Royal Straight Flush";
            else if (hand.IsStraightFlush()) handRank = "Straight Flush";
            else if (hand.IsFourOfAKind()) handRank = "Four Of A Kind";
            else if (hand.IsFullHouse()) handRank = "Full House";
            else if (hand.IsFlush()) handRank = "Flush";
            else if (hand.IsStraight()) handRank = "Straight";
            else if (hand.IsThreeOfAKind()) handRank = "Three of A Kind";
            else if (hand.IsTwoPair()) handRank = "Two Pair";
            else if (hand.IsPair()) handRank = "Pair";
            else handRank = "High Card";
            
            Console.WriteLine($"{player.Name}'s Hand:");
            hand.PrintHand();
            Console.WriteLine($"{player.Name}'s Hand Rank: {handRank}");
            Console.WriteLine();
       }
     
     
	}
}		
