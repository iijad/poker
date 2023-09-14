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
     
   //making a list to store objects of the class PlayerRank
   List<PlayerRank> playerRanks = new ArrayList<>();
   
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
   
 
   
   //Calculating and storing ranks for each players hand
   for (Player newPlayer : players) {
       System.out.println(newPlayer.getName() + " 's Hand:");
       newPlayer.getHand().printHand();
       String handRanks = newPlayer.getHand().rankHand();
       char flushSuit = newPlayer.getHand().getFlushSuit();
       //char tieSuit = newPlayer.getHand().getSuit();
       //System.out.println(" - " + handRanks);
       //System.out.println( "FS " + flushSuit);
       System.out.println();
       playerRanks.add(new PlayerRank(newPlayer, handRanks, flushSuit));
   }
   
   
   //Sorting players in order of first, then second, then third, etc...
   playerRanks.sort((pr1, pr2) -> {
       //Comparing the ranks
       int rankCompare = pr2.getRank().compareTo(pr1.getRank());  
       
       //If ranks are equal, compare suits
       if (rankCompare == 0) {
           if (pr1.getRank().equals("Straight") && pr2.getRank().equals("Straight")) {
               //If both hands are straights, compare the suit of the highest card
               return compareSuits(pr1.getSuit(), pr2.getSuit());
           } 
           else if (pr1.getRank().equals("Two Pair") && pr2.getRank().equals("Two Pair")) {
               int kickerCompare = compareSuits(pr1.getSuit(), pr2.getSuit());
               if (kickerCompare == 0) {
                   return pr1.getPlayer().getName().compareTo(pr2.getPlayer().getName());   
               }
               return kickerCompare;  
          } else if (pr1.getRank().equals("Pair") && pr2.getRank().equals("Pair")) {
              return compareSuits(pr1.getSuit(), pr2.getSuit());
          }else if (pr1.getRank().equals("High Card") && pr2.getRank().equals("High Card")){
              int highCard = compareSuits(pr1.getSuit(), pr2.getSuit());
              if (highCard == 0) {
                  return pr1.getPlayer().getName().compareTo(pr2.getPlayer().getName());
              } 
          } else {
               //Then compare the suits on specfic order
               int suitCompare = compareSuits(pr1.getSuit(), pr2.getSuit());
               
           
             if (suitCompare == 0) {
                 return pr1.getPlayer().getName().compareTo(pr2.getPlayer().getName());   
       }
       
       return suitCompare;
   }
 }
       
       return rankCompare;
   });
   
   
   
   //printing out each hand and rank in order
   System.out.println("//////////////////////////DA WINNERS//////////////////////////////////////////////////////");
   for (PlayerRank newPlayerRank : playerRanks) {
       System.out.println(newPlayerRank.getPlayer().getName() + " 's Hand:");
       newPlayerRank.getPlayer().getHand().sortHand();
       newPlayerRank.getPlayer().getHand().printHand();
       System.out.println(" - " + newPlayerRank.getRank());
       //System.out.println( " FS " + newPlayerRank.getSuit());
       System.out.println();
   }
  
       
   
    
    deck.printRemainingDeck();
    
    
        
       
    
	}
 private static int compareSuits(char suit1, char suit2) {
       // String suitOrder = "DCHS"; //The order is Diamonds, Clubs, Hearts, Spades
        String suitOrder = "SHCD"; // The order is Spades, Hearts, Clubs, Diamonds
        return suitOrder.indexOf(suit1) - suitOrder.indexOf(suit2);
    }

}

