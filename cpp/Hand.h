#ifndef HAND_H
#define HAND_H
#include <iostream>
#include "Cards.h"
#include <vector>
/* 
  This is the specification file for the Hand class. It has all the methods needed for a Hand and will
  be defined in the Hand.cpp file

*/

using namespace std;

class Hand {

public:
	Hand();
	void addCard(const Cards& card);
	void clear();
	void printHand() const;
	int getHandValue() const;
  string rankHand() const;
  string toString() const;

private:
	vector<Cards> cards;
};

#endif
	

