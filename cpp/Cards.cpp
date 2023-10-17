#include <iostream>
#include <string>
#include "Cards.h"
using namespace std;
//Card Class
Cards::Cards(char s, string r) : suit(s), rank(r) {}
//the getters for the suit and for the rank
char Cards::getSuit() const {
    return suit;
}

string Cards::getRank() const {
    return rank;
}
//formatting the cards in the order specifec (Ex AH = Ace of Hearts)
string Cards::toString() const {
    return rank + "" + suit;
}
//getting the value of the card
int Cards::getRankValue(const string& rank) const {
    if (rank == "2") return 2;  
       else if (rank == "3") return 3;
       else if (rank == "4") return 4;
       else if (rank == "5") return 5;
       else if (rank == "6") return 6;
       else if (rank == "7") return 7;
       else if (rank == "8") return 8;
       else if (rank == "9") return 9;
       else if (rank == "10") return 10;
       else if (rank == "J") return 11;
       else if (rank == "Q") return 12;
       else if (rank == "K") return 13;
        else if (rank == "A") return 14;
        else return -1;
} 
//the operations for comparing the cards
bool Cards::operator<(const Cards& o) const {
    return this->rank < o.rank;
}

 bool Cards::operator>(const Cards& o) const {
     return this->rank > o.rank;
 }
 //making sure a card is valid when making it
bool Cards::isValid() const {
    return !rank.empty() && suit != '\0';
}
