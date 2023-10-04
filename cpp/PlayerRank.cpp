#include "PlayerRank.h"
#include <iostream>

using namespace std;

PlayerRank::PlayerRank(const Player& player, const string& rank, char suit)
    :player(player), rank(rank), suit(suit) {
}


const Player& PlayerRank::getPlayer() const {
    return player;
}

const string& PlayerRank::getRank() const {
    return rank;
}

char PlayerRank::getSuit() const {
    return suit;
}

int PlayerRank::compareTo(const PlayerRank& other) const {
    return rank.compare(other.rank);
}

bool PlayerRank::operator<(const PlayerRank& other) const {
    return rank < other.rank;
}





