#ifndef DECK_H
#define DECK_H
#include "Cards.h"
#include <vector>
/* 
  This is the specification file for the Deck class. It has all the methods needed for a deck and will
  be defined in the Deck.cpp file

*/

class Deck {
    public:
        Deck();
        void shuffle();
        Cards drawCards();
        int cardsRemaining() const;
        void printDeck() const;
        void printRemainingDeck() const;
        vector<Cards> dealCards(int numCards);
        
    private:
        vector<Cards> cards;
};

#endif