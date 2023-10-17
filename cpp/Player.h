#ifndef PLAYER_H
#define PLAYER_H
#include "Hand.h"
#include "Cards.h"
/* 
  This is the specification file for the Player class. It has all the methods needed for a Player in the game and will
  be defined in the Player.cpp file

*/

#include <string>

using namespace std;

class Player {
    public:
        Player(const string& name);//: name(name), hand();
        void addToHand(const Cards& newCard);
        string getName() const;
        const Hand& getHand() const;
        string toString() const;
        
    private:
        string name;
        Hand hand;
        
};

#endif
        


