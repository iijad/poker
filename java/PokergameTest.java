import java.util.*;
import java.io.File;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;
public class PokergameTest {

	public static void main(String[] args) {
   
   Deck deck = new Deck();
   deck.shuffle();
   
   if (args.length == 0) { //if there is no argument, go to the main program
     System.out.println("*** USING RANDOMIZED DECK OF CARDS ***");
     System.out.println();
     System.out.println();
     System.out.println("*** Shuffled 52 card deck: "); 
   } else {//for the file
       System.out.println("*** USING TEST DECK ***");
       String file = args[0];
       readDeckFromFile(file);
       return;
   } 
   
   
   
   
   int numPlayers = 6;
   int cardsPerHand = 5;
   Hand newHand = new Hand();
   deck.printDeck();
   
   
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
   Collections.sort(playerRanks);
 
   
   //Calculating and storing ranks for each players hand
   System.out.println("Here are the six hands... ");
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
   System.out.println("//////////////////////////Winning Hand Order//////////////////////////////////////////////////////");
   for (PlayerRank newPlayerRank : playerRanks) {
       System.out.println(newPlayerRank.getPlayer().getName() + " 's Hand:");
       newPlayerRank.getPlayer().getHand().sortHand();
       newPlayerRank.getPlayer().getHand().printHand();
       System.out.println(" - " + newPlayerRank.getRank());
       //System.out.println( " FS " + newPlayerRank.getSuit());
       System.out.println();
   }
  
       
   
    deck.printRemainingDeck();
    
    
        
       
    
	}//comparing suits in case of a tie
 private static int compareSuits(char suit1, char suit2) {
       String suitOrder = "DCHS"; //The order is Diamonds, Clubs, Hearts, Spades
        //String suitOrder = "SHCD"; // The order is Spades, Hearts, Clubs, Diamonds
        return suitOrder.indexOf(suit1) - suitOrder.indexOf(suit2);
    }
    
    
 private static void readDeckFromFile(String filePath) {
        List<List<Cards>> allHands = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            Set<String> uniqueCards = new HashSet<>();
            System.out.println("File Name: " + filePath);
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
                String[] cardRecords = line.split(",");
                 if (cardRecords.length != 5) {
                        System.err.println("Invalid card record: " + cardRecords);
                        System.out.println(cardRecords.length);
                        continue;
                    }
                   for (String cardRecord : cardRecords) {
                    if (uniqueCards.contains(cardRecord)) {
                         System.out.println( " *** ERROR - DUPLICATE CARD FOUND IN DECK *** " );
                         System.err.println("DUPLICATE: " + cardRecord);
                         System.exit(1);
                    }
                    uniqueCards.add(cardRecord);
                }
                  if (cardRecords.length == 5){
                      List<Cards> newHand = new ArrayList<>();
                      for (String cardStr : cardRecords) {
                        String rank;
                        char suit;
                        if (cardStr.length() == 2) {
                            rank = cardStr.substring(0,1);
                            suit = cardStr.charAt(1);
                        } else if (cardStr.length() == 3) {
                            rank = cardStr.substring(0, 2);
                            suit = cardStr.charAt(2);
                        } else {
                            System.err.println("Invalid card format: " + cardStr);
                            continue;
                        }
                        Cards card = new Cards(rank, suit);
                        newHand.add(card);
                      }
                      allHands.add(newHand);
                  }
                   
            }
        } catch (IOException e) {
            System.err.println("Error reading the file: " + e.getMessage());
            System.exit(1);
        }
        
        if (allHands.size() < 5) {
            System.out.println("Not enough cards to make a hand.");
        } else {
            System.out.println("Here are the six hands...");
            for (int i = 0; i < 6; i++) {
                List<Cards> hand = allHands.get(i);
                System.out.println("Hand " + (i + 1) + ":");
                for (Cards card : hand) {
                    System.out.print(card + "\t");
                }
                System.out.println();
            }
        }

    }
}



