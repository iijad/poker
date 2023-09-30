#ifndef PLAYER_H
#define PLAYER_H
#include "Hand.h"
#include "Cards.h"


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
        


