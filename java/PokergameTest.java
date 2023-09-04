import java.util.*;
public class PokergameTest {

	public static void main(String[] args) {
		Cards card = new Cards("1", 'S');
		System.out.println(card);
		
   
   Deck deck = new Deck();
   deck.shuffle();
   
   
   for (int i=0; i < 5; i++)
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
   
   
   }

	}

}

