#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include "Deck.cpp"
#include "Cards.cpp"
#include "Hand.cpp"
#include "Player.cpp"
#include "PlayerRank.cpp"

using namespace std;


int main(int argc, char *argv[]) {
    Deck deck;
    deck.shuffle();
    if (argc == 1) {
        cout << "*** USING RANDOMIZED DECK OF CARDS ***" << endl;
    }
    if (argc > 1) {
        cout << "*** Shuffled 52 card Deck ***" << endl;
    }
    // Draw and print a few cards from the deck
   for (int i = 0; i < 5; i++) {
        Cards drawnCard = deck.drawCards();
        std::cout << "Drawn card: " << drawnCard.toString() << std::endl;
    }
    
    int numPlayers = 6;
    int cardsPerHand = 5;
    Hand newHand;
    deck.printDeck();
    
    vector<Player> players;
    for (int i = 1; i <= numPlayers; i++) {
        string playerName = " " + to_string(i);
        players.emplace_back(playerName);
    }
    
    for (const Player& player : players) {
        cout << player.getName() << endl;
    }
    
    vector<PlayerRank> playerRanks;
    for (int i=0; i < cardsPerHand; i++) {
        for (Player& player : players) {
            Cards newCard = deck.drawCards();
            if (newCard.isValid()) {
                player.addToHand(newCard);
            }
            else {
                cout << "The deck is empty." <<endl;
                break;
            }
        }
    }
    sort(playerRanks.begin(), playerRanks.end());
    
    
    //Calculating and storing the ranks in each hand
    cout << "Here are the six hands..." << endl;
    for (const Player& newPlayer : players) {
        cout << newPlayer.getName() << endl;
        newPlayer.getHand().printHand();
        string handRanks = newPlayer.getHand().rankHand();
        char flushSuit;
        cout << endl;
        //playerRanks.emplace_back(new PlayerRank(newPlayer, handRanks, flushSuit));
    }
    
    
    cout << "//////////////////////////Winning Hand Order//////////////////////////////////////////////////////" << std::endl;
     for (const PlayerRank& newPlayerRank : playerRanks) {
        std::cout << newPlayerRank.getPlayer().getName() << "'s Hand:" << std::endl;
        newPlayerRank.getPlayer().getHand()/*.sortHand()*/;
        newPlayerRank.getPlayer().getHand().printHand();
        std::cout << " - " << newPlayerRank.getRank() << std::endl;
        // std::cout << " FS " << newPlayerRank.getSuit() << std::endl;
        std::cout << std::endl;
    }
    
    std::cout << "Remaining cards in the deck: " << deck.cardsRemaining() << std::endl;
    
    return 0;
}
