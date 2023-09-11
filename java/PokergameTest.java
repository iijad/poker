import java.util.*;
public class PokergameTest {

	public static void main(String[] args) {
		//Cards card = new Cards("1", 'S');
		//System.out.println(card);
		
   
   Deck deck = new Deck();
   deck.shuffle();
   
   int numPlayers = 5;
   int cardsPerHand = 5;
   Hand newHand = new Hand();
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
   
   // Creating and dealing hands to players
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
   
   //making a list to store objects of the class PlayerRank
   List<PlayerRank> playerRanks = new ArrayList<>();
   
   //Calculating and storing ranks for each players hand
   for (Player newPlayer : players) {
       String handRanks = newPlayer.getHand().rankHand();
       char flushSuit = newPlayer.getHand().getFlushSuit();
       playerRanks.add(new PlayerRank(newPlayer, handRanks, flushSuit));
   }
   
   
   //Sorting players in order of first, then second, then third, etc...
   playerRanks.sort((pr1, pr2) -> {
       //Comparing the ranks
       int rankCompare = pr2.getRank().compareTo(pr1.getRank());
       
       //If ranks are equal, compare suits
       if (rankCompare == 0) {
           int suitCompare = compareSuits(pr1.getSuit(), pr2.getSuit());
           
           if (suitCompare == 0) {
               return pr1.getPlayer().getName().compareTo(pr2.getPlayer().getName());   
       }
       
       return suitCompare;
   }
       
       return rankCompare;
   });
   
   
   //printing out each hand and rank in order
   
   for (PlayerRank newPlayerRank : playerRanks) {
       System.out.println(newPlayerRank.getPlayer().getName() + " 's Hand:");
       newPlayerRank.getPlayer().getHand().printHand();
       System.out.println(" - " + newPlayerRank.getRank());
       //System.out.println( " FS " + newPlayerRank.getSuit());
       System.out.println();
   }
  
       
   
   
   //printing out each hand
  /*  for (Player newPlayer : players) {
        System.out.println(newPlayer.getName() + " 's Hand: ");
        newPlayer.getHand().printHand();
        String handRank = newPlayer.getHand().rankHand();
        System.out.println(" - " + handRank);
        System.out.println();
    } */
    
    deck.printRemainingDeck();
    
    
	}
 private static int compareSuits(char suit1, char suit2) {
        String suitOrder = "DCHS"; //The order is Diamonds, Clubs, Hearts, Spades
        return suitOrder.indexOf(suit1) - suitOrder.indexOf(suit2);
    }

}

