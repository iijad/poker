#include "Deck.h"
#include <stdexcept>
#include <iostream>
#include <algorithm> // For std::shuffle
#include <random>    // For std::default_random_engine

using namespace std;

Deck::Deck() {
    //initailizing the deck, 52
    const char suits[] = {'H', 'D', 'S', 'C'};
    const string ranks[] = {"2", "3", "4" "5", "6", "7", "8", "9", "10" , "J", "Q", "K", "A"};
    
    for (char suit: suits){
        for (const string &rank: ranks) {
            cards.push_back(Cards(suit,rank));
        }
    }
}

void Deck::shuffle() {
    random_shuffle(cards.begin(), cards.end());
}

Cards Deck::drawCards() {
    if (!cards.empty()) {
        Cards drawCard = cards.back();
        cards.pop_back();
        return drawCard;
    } else {
        throw runtime_error("The deck is empty");
    }
}

int Deck::cardsRemaining() const {
    return cards.size();
}

void Deck::printDeck() const {
    int count = 0;
    
    for (const Cards &card : cards) {
        cout << card.toString() << "\t";
        count++;
        if ((count + 1) % 13 == 0) {
            cout << endl;
        }
    }
}

void Deck::printRemainingDeck() const {
    cout << "Remaining cards in the deck: " << cardsRemaining() << endl;
    }
    
vector<Cards> Deck::dealCards(int numCards) {
    vector<Cards> dealtCards;
    
    for (int i= 0; i < numCards; i++) {
        if (!cards.empty()) {
            Cards drawnCard = drawCards();
            dealtCards.push_back(drawnCard);
        } else {
            throw runtime_error("Not enough cards to deal");
        }
    }
    return dealtCards;
}
