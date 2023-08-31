public class Cards {
	
	private char rank;
	private char suit;
	
	//creating the constructor for the card class. Using this to eliminate confusion between the variables
	public Cards(char rank, char suit) {
		this.rank = rank;
		this.suit = suit;
		
			
	}
	
	//returns the rank of the card
		public char getRank() {
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
	
	
	//try method that uses 4 loops to populate the array that will be the card deck

}

