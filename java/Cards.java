import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
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
  //migbt have to come back to this method to deal the cards in the order that is asked
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
  
  
   
 
 }

