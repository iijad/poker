import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
//if things get hariy, change both types to strings
 class Cards {
	
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
	
	
	
	//using an overridden toString method to return the card in order of the number, then rank
	@Override
	public String toString() {
		return rank +""+ suit;
		
	}
	

 
/////DECK CLASS///////////////////////////////////////////////////////////////////////////

}
	//creating a class for making a deck
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
  //might have to come back to this method to deal the cards in the order that is asked
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
 
 public void printRemainingDeck(){
   System.out.println();
   System.out.println("Remaining Cards in Deck: " + "\t"); 
   for (Cards card: cards) {
     System.out.print(card.toString() + "\t");
     }
   }
  
 }
 
 
   //creating the class for making a hand//////////////////////////////////////////////////////////////
   
 class Hand {
   private final List<Cards> cards;
   
   public Hand() {
     cards = new ArrayList<>();
     
   }
   
   public void addCard (Cards card) {
     cards.add(card);
   
   }
   
   public List<Cards> getCards() {
     return cards;
     
   }
   
   //Maybe quarentine
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
     //Creating a hash map to rank them hands
     Map<String,Integer> rankCounts = new HashMap<>();
     for (Cards newCard: cards) {
       String rank = newCard.getRank();
       rankCounts.put(rank, rankCounts.getOrDefault(rank, 0) + 1);
     }
     
     if (rankCounts.containsValue(4)) {
       return "Four of a Kind" ;
     }
     else if (rankCounts.containsValue(3) && rankCounts.containsValue(2)) {
       return "Full House" ;
     }
     
     List<String> rankOfHand = new ArrayList<>();
     return "String";
 
 }
   

   //PLAYER CLASS////////////////////////////////////////////////////////////////////
   
 class Player {
   private final String name ;
   private final Hand hand;
   
 
   public Player (String name) {
     this.name = name;
     this.hand = new Hand();
     
   }
   
   public void addingToHand(Cards newCard)
   {
     hand.addCard(newCard);
   }
   
   public Hand gethand(){
     return hand;
   }
   
   @Override
   public String toString() {
     return name + " Hand: \n" + hand.toString();
     
   }
 }
 

   
 
 
 
 
 
 
 
 
 
 
 
 }

   
   
 

