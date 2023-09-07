import java.util.*;
public class PokergameTest {

	public static void main(String[] args) {
		//Cards card = new Cards("1", 'S');
		//System.out.println(card);
		
   
   Deck deck = new Deck();
   deck.shuffle();
   
   int numPlayers = 5;
   int cardsPerHand = 5;
   deck.printDeck();
   
  /* for (int i=0; i < 5; i++)
   {
     Cards card2 = deck.dealingCards();
     if (card2 != null)
     {
       System.out.println("Dealing: " + card2);
     }
     else{
       System.out.println("The deck is empty");
       break;
     
     }
   
   
   }*/
   
   List<Player> players = new ArrayList<>();
   for (int i = 1; i <= numPlayers; i++)
     {
       players.add(new Player("Player " + i));
     }
   
   for (int i=0; i < cardsPerHand; i++) {
       for (Player player: players) {
           Cards newCard = deck.dealingCards();
           if (newCard!= null) { 
               player.addingToHand(newCard);
           }
           else {
               System.out.println("The deck is empty.");
               break;
           }
       }
   
   }
   
   //printing out each hand
    for (Player player: players) {
      System.out.print(player);
    }
    
   deck.printRemainingDeck();
	}

}

