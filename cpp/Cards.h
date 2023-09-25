#ifndef CARDS_H
#define CARDS_H


#include <string>


using namespace std;

class Cards {
    public:
        Cards(char s, string r);
        char getSuit() const;
        string getRank() const;
        string toString() const;
        int getRankValue(const string& rank) const;
        bool operator<(const Cards& o) const;
        bool operator>(const Cards& o) const;
        
    private:
        char suit;
        string rank;
        
};



#endif 

            




