import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.Comparator;
//if things get hariy, change both types to strings
 class Cards implements Comparable<Cards>{
	
	private String rank;
	private char suit;
	
	//creating the constructor for the card class. Using this to eliminate confusion between the variables
	public Cards(String rank, char suit) {
		this.rank = rank;
		this.suit = suit;
		
			
	}
	
	//returns the rank of the card
		public String getRank() {
			return rank;
		}
	
	
	//returns the suit of the card
	public char getSuit() {
		return suit;
	}
 
 
	//overide the compareTo method to compare each hand
	@Override  
    public int compareTo(Cards o) {
        return this.rank.compareTo(o.rank);
    }
	
	//using an overridden toString method to return the card in order of the number, then rank
	@Override
	public String toString() {
		return rank +""+ suit;
		
	}
 
 //using switch cases to change the string value to the value it represents
 
 public static int getRankValue(String rank){
   switch(rank) {
       case "2": return 2;
       case "3": return 3;
       case "4": return 4;
       case "5": return 5;
       case "6": return 6;
       case "7": return 7;
       case "8": return 8;
       case "9": return 9;
       case "10": return 10;
       case "J": return 11;
       case "Q": return 12;
       case "K": return 13;
       case "A": return 14;
       default: return -1;
   }
 }
	


}

/////DECK CLASS///////////////////////////////////////////////////////////////////////////


	class Deck {
   //creating a private final variable since the deck will never change
   private final List<Cards> cards;
   
   public Deck() {
   cards = new ArrayList<>();
   char[] suits = { 'S' , 'H' , 'D', 'C'};
   String [] ranks = { "2", "3", "4", "5" , "6", "7", "8", "9", "10" , "J", "Q", "K", "A"};
   
   for (char suit: suits) {
     for (String rank: ranks){
       cards.add(new Cards(rank, suit));
       }
     }
   
   
   }
   
 //shuffles the deck
  public void shuffle(){
    Collections.shuffle(cards);
  
  } 
  
  //dealing cards
  public Cards dealingCards(){
    if (!cards.isEmpty())
    {
      return cards.remove(0);
    }
    return null;
  }
  
  //retruns the size of the deck
  public int size(){
    return cards.size();
  
  }
  
  // printing the deck
  public void printDeck(){
  int count = 0;
  
  for (Cards card: cards) {
    System.out.print(card.toString() + "\t");
    count++;
    if (count % 13 ==0) {
        System.out.println();
    }
  }
 }
 
 //printing what is remaining in the deck
 public void printRemainingDeck(){
   System.out.println();
   System.out.println("Remaining Cards in Deck: " + "\t"); 
   for (Cards card: cards) {
     System.out.print(card.toString() + "\t");
     }
   }
  
 }
 
 
   //creating the class for making a HAND//////////////////////////////////////////////////////////////
   
 class Hand implements Comparable<Hand> {
   private final List<Cards> cards;
   
   public Hand() {
     cards = new ArrayList<>();
     Collections.sort(cards); //This one line took me 5 hours to do
     
   }
   
   //adding a card to the hand
   public void addCard (Cards card) {
     cards.add(card);
   
   }
   
   //returning the cards
   public List<Cards> getCards() {
     return cards;
     
   }
 
    public void sortHand() {
        Collections.sort(cards, new Comparator<Cards>() {
        
        @Override
        public int compare(Cards card1, Cards card2) {
            return card1.getSuit() - card2.getSuit();
          }
        });
      } 
      
    //overide the compareTo method to compare each hand  
    @Override  
    public int compareTo(Hand o) {
        return this.rankHand().compareTo(o.rankHand());
    }
       
   
   //printing out the hands
   public void printHand(){
       int count = 0;
       for (Cards newCard: cards){
           System.out.print(newCard.toString() + "\t");
           count++;
           if (count % 5 == 0){
               System.out.println();
           }
       }
   }
               
   
   @Override 
   public String toString() {
   // StringBuilder It constructs a blank string builder with a capacity of 16 characters. 
   
     StringBuilder handString = new StringBuilder();
     int count = 0;
     for (Cards card : cards) {
       handString.append(card.toString()).append("\t");
       count++;
       if (count % 5 == 0){
         System.out.println();
       }
     }
   return handString.toString();
 }
 
   public String rankHand() {
     //Creating a hash map to rank them hands, come back for formatting
     Map<Character, Integer> suitCounts = new HashMap<>(); //for the suits
     Map<String, Integer> rankCounts = new HashMap<>();  //for the ranks
     for (Cards newCard: cards) {
       char suit = newCard.getSuit();
       String rank = newCard.getRank();
       suitCounts.put(suit, suitCounts.getOrDefault(suit, 0) + 1);
       rankCounts.put(rank, rankCounts.getOrDefault(rank, 0) + 1);
     }
     
     if (suitCounts.size() == 1 && rankCounts.size() == 5) {
         if (isRoyalStraightFlush(rankCounts.keySet(), suitCounts.keySet().iterator().next())) {
             return "Royal Straight Flush";
         }
         
         return "Straight Flush";
     }
     
     if (suitCounts.size() == 1 &&  rankCounts.size() == 5) {
         if (isStraight(rankCounts.keySet())) {
         return "Straight Flush";
       }
       return "Flush";
     }
     
     if (rankCounts.containsValue(4)) {
         return "Four of a Kind"; //4 of each number (A, 2, 3....)
     }
     
     if (rankCounts.containsValue(3) && rankCounts.containsValue(2)) {
         return "Full House"; 
     }
     
     if (rankCounts.size() == 5 && isStraight(rankCounts.keySet())) {
       return "Straight" ;
     }
     
     
     if (rankCounts.containsValue(3)) {
         return "Three of a Kind"; // 3 of each number
     }
     
 
     if (rankCounts.containsValue(2)) { // for getting pairs
         int pairCount = 0;
         for (int newCount : rankCounts.values()) {
             if (newCount == 2) {
                 pairCount++;
             }
         }
         if (pairCount == 2) {
             return "Two Pair";
         } else {
             return "Pair";
         }
     }
     
     return "High Card";
   }
         
     
   
 public char getFlushSuit() {
     Map<Character, Integer> suitCounts = new HashMap<>();
     for (Cards newCard : cards) {
         char newSuit = newCard.getSuit();
         suitCounts.put(newSuit, suitCounts.getOrDefault(newSuit, 0) + 1);
     }
     
     for (char newSuit : suitCounts.keySet()) {
         if (suitCounts.get(newSuit) >= 5) {
             return newSuit;
         }
     }
     
     return ' ' ; // there is No flush ani
 }
 
 
 
 /*private boolean isFlush() {
    char suit = cards.get(0).getSuit();
   for (Cards newCard : cards) {
       if (newCard.getSuit().charAt(1) != suit.charAt(0)) {
           return false; 
       }
   }
 
   return true;
 } */
 
 
 private boolean isRoyalStraightFlush(Set<String> ranks, char suit) {
     //checking for the sequence of 10, J, Q, K, A
     
     return ranks.containsAll(Arrays.asList("10", "J", "Q", "K", "A"));
 }
 
 
 private boolean isStraight(Set<String> ranks) {
     List<Integer> rankValues = new ArrayList<>();
     for (String newRank : ranks) {
         rankValues.add(Cards.getRankValue(newRank));
     }
     
     Collections.sort(rankValues);
     
     int min = rankValues.get(0);
     int max = rankValues.get(rankValues.size() - 1);
     
     if (max - min == 4 && ranks.size() == 5) {
         return true;
     }
     
     //check for an Ace low straight (A, 2, 3, 4, 5)
     if (ranks.contains("A") && ranks.contains("2") && ranks.contains("3") && ranks.contains("4") && ranks.contains("5")) {
         return true;
     }
     
     
     return false;


   }
 }

   

   //PLAYER CLASS////////////////////////////////////////////////////////////////////
   
  class Player {
   private final String name;
   private final Hand hand;
   
 
   public Player (String name) {
     this.name = name;
     this.hand = new Hand();
     
   }
   
   public void addingToHand(Cards newCard)
   {
     hand.addCard(newCard);
   }
   
   public String getName() {
       return name;
   }
   
   public Hand getHand(){
     return hand;
   }
   
   @Override
   public String toString() {
     //return name + " Hand: \n" + hand.toString();
     return name;
     
   }
 }
 
 class PlayerRank implements Comparable<PlayerRank> {
   private final Player player;
   private final String rank;
   private final char suit; //used for tiebreakers
   
   public PlayerRank(Player player, String rank, char suit) {
         this.player = player;
         this.rank = rank;
         this.suit = suit;
   }
   
   public Player getPlayer() {
       return player;
   }
   
   public String getRank() {
       return rank;
   }
   
   @Override
    public int compareTo(PlayerRank other) {
        return this.rank.compareTo(other.rank);
    }
   
   public char getSuit() {
       return suit;
   }

   
   
 
 
 
 
 
 
 }
 
 

   
 
 
 
 
 
 
 
 
 
 
 
 

   
   
 

