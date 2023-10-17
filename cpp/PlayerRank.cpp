#include "PlayerRank.h"
#include <iostream>

using namespace std;
//PlayerRank Class
PlayerRank::PlayerRank(const Player& player, const string& rank, char suit)
    :player(player), rank(rank), suit(suit) {
}

//returning the player 
const Player& PlayerRank::getPlayer() const {
    return player;
}
//getting the rank for each player to use in ranking
const string& PlayerRank::getRank() const {
    return rank;
}
//getting the suit for each player to use in ranking
char PlayerRank::getSuit() const {
    return suit;
}
// comparing each player and playerRank
int PlayerRank::compareTo(const PlayerRank& other) const {
    return rank.compare(other.rank);
}

bool PlayerRank::operator<(const PlayerRank& other) const {
    return rank < other.rank;
}





