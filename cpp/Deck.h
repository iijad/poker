#ifndef DECK_H
#define DECK_H
#include "Cards.h"
#include <vector>


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