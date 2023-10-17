#ifndef PLAYERRANK_H
#define PLAYERRANK_H

#include "Player.h"

/* 
  This is the specification file for the PlayerRank class. It has all the methods needed to rank each player and will
  be defined in the PlayerRank.cpp file

*/
using namespace std;

class PlayerRank {
    public:
        PlayerRank(const Player& player, const string& rank, char suit);
        const Player& getPlayer() const;
        const string& getRank() const;
        int compareTo(const PlayerRank& other) const;
        char getSuit() const;
        bool operator<(const PlayerRank& other) const;
    
    private:
        Player player;
        string rank;
        char suit;
};
        
#endif

