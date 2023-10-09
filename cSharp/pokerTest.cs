using System;

class pokerTest
{
	 public static void Main( String[] args)
	{
		Cards myCard = new Cards('H', "A"); // 'H' represents Hearts, "A" represents the rank
   
   // Access card properties
        Console.WriteLine($"Card Suit: {myCard.Suit}");
        Console.WriteLine($"Card Rank: {myCard.Rank}");

        // Get and display the card's name
        Console.WriteLine($"Card Name: {myCard.GetDisplayName()}"); // Output: "Card Name: Ace of H"
        
        Console.WriteLine($"Card Rank Value: {myCard.GetRankValue()}"); // Output: "Card Rank Value: 1"
	}
}		
