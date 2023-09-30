#include "Player.h"
#include <iostream>

using namespace std;

Player::Player(const string& name): name(name), hand() {
}

void Player::addToHand(const Cards& newCard) {
    hand.addCard(newCard);
}

string Player::getName() const {
    return name;
}

const Hand& Player::getHand() const {
    return hand;
}

string Player::toString() const {
    return name;
}
    