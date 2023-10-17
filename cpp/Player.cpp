#include "Player.h"
#include <iostream>

using namespace std;
//Player Class
Player::Player(const string& name): name(name), hand() {
}
//adding a card to each player
void Player::addToHand(const Cards& newCard) {
    hand.addCard(newCard);
}
//getting the name for each player (just a placeholder since we dont need to print the player's name)
string Player::getName() const {
    return name;
}
//gettting the hand for each player
const Hand& Player::getHand() const {
    return hand;
}
//formatting each player 
string Player::toString() const {
    return name;
}
    