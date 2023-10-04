#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <algorithm>
#include "Deck.cpp"
#include "Cards.cpp"
#include "Hand.cpp"
#include "Player.cpp"
#include "PlayerRank.cpp"

using namespace std;

vector<Cards> readDeckFromFile(const string& filePath) {
    vector<Hand> hands;
    vector<Cards> cards;

    ifstream file(filePath);
    if (!file.is_open()) {
        cerr << "Error opening file: " << filePath << std::endl;
        return cards;
    }

     string line;
     cout << "File Name: " << filePath <<  endl;
    while ( getline(file, line)) {
         cout << line <<  endl;
         vector< string> cardRecords;
        size_t pos = 0;
        while ((pos = line.find(',')) !=  string::npos) {
            cardRecords.push_back(line.substr(0, pos));
            line.erase(0, pos + 1);
        }
        cardRecords.push_back(line);

        if (cardRecords.size() != 5) {
             cerr << "Invalid card record: ";
            for (const  string& record : cardRecords) {
                 cerr << record << ",";
            }
             cerr <<  endl;
            continue;
        }

        // Process cardRecords and create Cards objects
        // Add them to the 'cards' vector as needed
    }

    return cards;
}


int main(int argc, char *argv[]) {
    Deck deck;
    deck.shuffle();
    if (argc == 1) {
        cout << "*** USING RANDOMIZED DECK OF CARDS ***" << endl;
    }
    if (argc > 1) {
        cout << "*** Shuffled 52 card Deck ***" << endl;
        string filePath = "your_file_path_here.txt";
        vector<Cards> deck = readDeckFromFile(filePath);
    }
    // Draw and print a few cards from the deck
   for (int i = 0; i < 5; i++) {
        Cards drawnCard = deck.drawCards();
         cout << "Drawn card: " << drawnCard.toString() <<  endl;
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
    
    
    cout << "//////////////////////////Winning Hand Order//////////////////////////////////////////////////////" <<  endl;
     for (const PlayerRank& newPlayerRank : playerRanks) {
         cout << newPlayerRank.getPlayer().getName() << "'s Hand:" <<  endl;
        newPlayerRank.getPlayer().getHand()/*.sortHand()*/;
        newPlayerRank.getPlayer().getHand().printHand();
         cout << " - " << newPlayerRank.getRank() <<  endl;
        //  cout << " FS " << newPlayerRank.getSuit() <<  endl;
         cout <<  endl;
    }
    
     cout << "Remaining cards in the deck: " << deck.cardsRemaining() <<  endl;
    
    return 0;
}
