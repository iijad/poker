#include "Hand.h"
#include <iostream>
#include <vector>
#include <algorithm>
#include <bits/stdc++.h>
using namespace std;


Hand::Hand() {

cards = vector<Cards>();
sort(cards.begin(), cards.end());

}

void Hand::addCard(const Cards& card) {
	cards.push_back(card);
}

void Hand::clear() {
	cards.clear();
}

void Hand::printHand() const {
	for (const Cards& card : cards) {
		cout << card.toString() << endl;
	}
} 

int Hand::getHandValue() const {
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
} 

string Hand::rankHand() const {
    vector<Cards> sortedCards = cards;
    sort(sortedCards.begin(), sortedCards.end(), [](const Cards& a, const Cards& b) {
        return stoi(a.getRank()) < stoi(b.getRank());
    });
    
    bool isFlush = true;
    int pairCount = 0;
    int threeOfAKind = 0;
    int fourOfAKind = 0;
    
    for (size_t i = 0; i < sortedCards.size()-1; i++) {
        if (sortedCards[i].getRank() == sortedCards[i + 1].getRank()) {
            pairCount++;
            if (pairCount == 1) {
                return "Pair";
            } else if (pairCount == 2) {
                return "Two Pair";
            }
        }
    if (i < sortedCards.size() -2 && 
        sortedCards[i].getRank() == sortedCards[i + 1].getRank() &&
        sortedCards[i].getRank() == sortedCards[i + 2].getRank()) {
            threeOfAKind++;
            return "Three of A Kind";
    }
    if (i < sortedCards.size() - 3 &&
        sortedCards[i].getRank() == sortedCards[i + 1].getRank() &&
        sortedCards[i].getRank() == sortedCards[i + 2].getRank() &&
        sortedCards[i].getRank() == sortedCards[i + 3].getRank()) {
            fourOfAKind++;
            return "Four of A Kind";
    }
    if (sortedCards[i].getSuit() != sortedCards[i + 1].getSuit()) {
        isFlush == false;
    }
}

if (isFlush) { 
    return "Flush";
}

if (isFlush) {
    bool isStraight = true;
    for (size_t i = 0; i < sortedCards.size() -1; i++) {
        if (stoi(sortedCards[i].getRank()) != stoi(sortedCards[i + 1].getRank()) -1) {
            isStraight = false;
            break;
        }
    }
    if (isStraight) {
        if (sortedCards[0].getRank() == "10" && sortedCards[1].getRank() == "Jack" &&
            sortedCards[2].getRank() == "Queen" && sortedCards[3].getRank() == "King" &&
            sortedCards[4].getRank() == "Ace") {
                return "Royal Striaght Flush";
        }
        
        return "Straight Flush";
    }
}
if (pairCount == 1  && threeOfAKind == 1) {
    return "Full House";
}

bool isStraight = true;
for (size_t i = 0; i < sortedCards.size() - 1; i++) {
        if (std::stoi(sortedCards[i].getRank()) != std::stoi(sortedCards[i + 1].getRank()) - 1) {
            isStraight = false;
            break;
        }
}
if (isStraight) {
    return "Straight";
}

return "High Card";
}

string Hand::toString() const {
    ostringstream handString;
    int count = 0;
    
    for (const Cards& card : cards) {
        handString << card.toString() << "\t";
        count++;
        if (count % 5 == 0) {
            handString << endl;
        }
    }
    
    return handString.str();
}
    
    
    
    

        
			
