#ifndef HAND_H
#define HAND_H
#include <iostream>
#include "Cards.h"
#include <vector>

using namespace std;

class Hand {

public:
	Hand();
	void addCard(const Cards& card);
	void clear();
	void printHand() const;
	int getHandValue() const;

private:
	vector<Cards> cards;
};

#endif //HAND_H
	

