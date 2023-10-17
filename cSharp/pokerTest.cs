using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

class pokerTest
{
    static void Main(string[] args)
    {
        //Getting the command line arguments for the Decks. If the command isnt there, it defaults to the random deck
        if (args.Length == 0)
        {
            Console.WriteLine("*** P O K E R   H A N D   A N A L Y S E R ***");
            Console.WriteLine();
            Console.WriteLine("***USING RANDOMIZED DECK OF CARDS***");
            Console.WriteLine();
            Console.WriteLine();
            Console.WriteLine("***SHUFFLED 52 CARD DECK***");
            
        }
        else 
        {
            Console.WriteLine("*** P O K E R   H A N D   A N A L Y S E R ***");
            Console.WriteLine();
            Console.WriteLine("***USING TEST DECK***");
            string filePath = args[0];
            List<List<Cards>> allHands = ReadDeckFromFile(filePath);
            if (allHands.Count < 5)
            {
                Console.WriteLine("Not enough cards to make a hand.");
            }
            else if (args.Length == 1)
            {
                Console.WriteLine("Here are the six hands...");
                for (int i = 0; i < 6; i++)
                {
                    List<Cards> hand = allHands[i];
                    int cardsPrinted = 0;
                    foreach (Cards card in hand)
                    {
                        Console.Write(card + "\t");
                        cardsPrinted++;
                        if (cardsPrinted >= 5)
                        {
                            // Start a new line after printing 5 cards
                            Console.WriteLine();
                            cardsPrinted = 0; // Reset the counter
                        }
                    }
                    Console.WriteLine();
                }
                Environment.Exit(0);
            }
        }
        
            ///Continuing after the command line
            Deck deck = new Deck();
            deck.Shuffle();
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
                .ThenByDescending(item =>
                {
                    if (item.Hand.IsPair()) return item.Hand.GetSuitOfHighestNonPairCard();
                    if (item.Hand.IsTwoPair()) return item.Hand.GetSuitOfNonPairCard();
                    if (item.Hand.IsThreeOfAKind()) return item.Hand.GetSuitOfNonPairCard();
                    if (item.Hand.IsStraight()) return item.Hand.GetSuitOfHighestCardInStraight();
                    if (item.Hand.IsFlush()) return item.Hand.GetSuitOfHighestCardInStraight();
                    if (item.Hand.IsFourOfAKind()) return item.Hand.GetSuitOfNonPairCard();
                    if (item.Hand.IsFullHouse()) return item.Hand.GetSuitOfNonPairCard();
                    return ' '; // No tiebreaker needed for Royal Straight Flush
                })
                .Select(item => item.Player)
                .ToList();

            // Print the remaining cards in the deck
            Console.WriteLine("*** Here is what remains in the deck...");
            deck.PrintDeck();
            Console.WriteLine();

            // Print the hands of the players
            Console.WriteLine("*** Here are the 6 hands...");
            for (int i = 0; i < 6; i++)
            {
                List<Cards> playerCards = players[i].GetHand();
                for (int j = 0; j < playerCards.Count; j++)
                {
                    Console.Write(playerCards[j].GetDisplayName());
                    if ((j + 1) % 5 == 0 || j == playerCards.Count - 1)
                    {
                        // Start a new line after every 5 cards or at the end of the list
                        Console.WriteLine();
                    }
                    else
                    {
                        // Add a tab or space to separate cards on the same line
                        Console.Write("\t");
                    }
                }
            }
            //Getting the winning order of the hands
            Console.WriteLine();
            Console.WriteLine("--- WINNING HAND ORDER ---");
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
                Console.WriteLine();
                hand.PrintHand();
                Console.WriteLine($"- {handRank}");
                Console.WriteLine();
            }
        }
    

    static List<List<Cards>> ReadDeckFromFile(string filePath)
    {
        List<List<Cards>> allHands = new List<List<Cards>>();
        try
        {
            using (StreamReader reader = new StreamReader(filePath))
            {
                string line;
                HashSet<string> uniqueCards = new HashSet<string>();
                Console.WriteLine("File Name: " + filePath);
                while ((line = reader.ReadLine()) != null)
                {
                    Console.WriteLine(line);
                    string[] cardRecords = line.Split(',');
                    if (cardRecords.Length != 5)
                    {
                        Console.Error.WriteLine("Invalid card record: " + string.Join(",", cardRecords));
                        Console.WriteLine(cardRecords.Length);
                        continue;
                    }
                    foreach (string cardRecord in cardRecords)
                    {
                        if (uniqueCards.Contains(cardRecord))
                        {
                            Console.WriteLine(" *** ERROR - DUPLICATE CARD FOUND IN DECK *** ");
                            Console.Error.WriteLine("DUPLICATE: " + cardRecord);
                            Environment.Exit(1);
                        }
                        uniqueCards.Add(cardRecord);
                    }
                    if (cardRecords.Length == 5)
                    {
                        List<Cards> newHand = new List<Cards>();

                        foreach (string cardStr in cardRecords)
                        {
                            string rank;
                            char suit;

                            if (cardStr.Length == 2)
                            {
                                rank = cardStr.Substring(0, 1);
                                suit = cardStr[1];
                            }
                            else if (cardStr.Length == 3)
                            {
                                rank = cardStr.Substring(0, 2);
                                suit = cardStr[2];
                            }
                            else
                            {
                                Console.Error.WriteLine("Invalid card format: " + cardStr);
                                continue;
                            }
                            Cards card = new Cards(suit, rank);
                            newHand.Add(card);
                        }
                        allHands.Add(newHand);
                    }
                }
            }
        }
        catch (IOException e)
        {
            Console.Error.WriteLine("Error reading the file: " + e.Message);
            Environment.Exit(1);
        }
        return allHands;
    }
}
