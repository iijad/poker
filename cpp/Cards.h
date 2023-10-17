#ifndef CARDS_H
#define CARDS_H


#include <string>


using namespace std;
/*
  This is the specification class for the Card class. It contains all the methods needed and will be defined in the 
  Cards.cpp file
*/
class Cards {
    public:
        Cards(char s, string r);
        char getSuit() const;
        string getRank() const;
        string toString() const;
        int getRankValue(const string& rank) const;
        bool operator<(const Cards& o) const;
        bool operator>(const Cards& o) const;
        bool isValid() const;
        
    private:
        char suit;
        string rank;
        
};



#endif 

            




