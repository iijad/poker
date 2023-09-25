#include "Hand.h"
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;


Hand::Hand() {

//cards = vector<Cards>();
//sort(cards.begin(), cards.end());

}

void Hand::addCard(const Cards& card) {
	cards.push_back(card);
}

void Hand::clear() {
	cards.clear();
}

/*void Hand::printHand() const {
	for (const Cards& card : cards) {
		cout << card.toString() << endl;
	}
} */

/*int Hand::getHandValue() const {
	int value = 0;
	int numAces = 0;

	for (const Cards& card : cards) {
		if (card.getRank() == "A") {
			value+= 14;
			numAces++;
		} else if (card.getRank() == "K") {
			value+=13;
		} else if (card.getRank() == "Q") {
			value+=12;
		} else if (card.getRank() == "J") {
			value+=11;
		} else {
			int rankValue = stoi(card.getRank());
			value+= rankValue;
		}
}

while (value > 21 && numAces > 0) {
	value-=7;
	numAces--;
}
return value;
} */
			
