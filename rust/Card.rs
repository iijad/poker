#!/usr/bin/rust
#[derive(Debug, Eq, PartialEq, Ord, PartialOrd, Clone)]
use rand::seq::SliceRandom;
use std::collections::{HashMap, HashSet};
use std::cmp::Ordering;

struct Card {
    suit: char,
    rank: String,
}

// Constructor
impl Card {
    // Constructor
    fn new(rank: &str, suit: char) -> Card {
        Card {
            rank: String::from(rank),
            suit,
        }
    }


 // Method to get the rank of the card
    fn get_rank(&self) -> &str {
        &self.rank
    }
    
// Method to get the suit of the card
    fn get_suit(&self) -> char {
        self.suit
    }



// Method to get the rank value as an integer
    fn get_rank_value(&self) -> i32 {
        match self.rank.as_str() {
            "2" => 2,
            "3" => 3,
            "4" => 4,
            "5" => 5,
            "6" => 6,
            "7" => 7,
            "8" => 8,
            "9" => 9,
            "10" => 10,
            "J" => 11,
            "Q" => 12,
            "K" => 13,
            "A" => 14,
            _ => -1,
        }
    }
}

struct Deck {
    cards: Vec<Cards>,
}

impl Deck {
    fn new() -> Deck {
        let mut cards = Vec::new();
        let suits = ['S', 'H', 'D', 'C'];
        let ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"];

        for &suit in suits.iter() {
            for &rank in ranks.iter() {
                cards.push(Cards::new(rank, suit));
            }
        }

        Deck { cards }
    }

    fn shuffle(&mut self) {
        let mut rng = rand::thread_rng();
        self.cards.shuffle(&mut rng);
    }

    fn dealing_cards(&mut self) -> Option<Cards> {
        if !self.cards.is_empty() {
            Some(self.cards.remove(0))
        } else {
            None
        }
    }

    fn size(&self) -> usize {
        self.cards.len()
    }

    fn print_deck(&self) {
        let mut count = 0;

        for card in self.cards.iter() {
            print!("{}\t", card);
            count += 1;
            if count % 13 == 0 {
                println!();
            }
        }
    }

    fn print_remaining_deck(&self) {
        println!("\n*** Here is what remains in the deck...:\t");
        for card in self.cards.iter() {
            print!("{}\t", card);
        }
        println!();
    }
}

#[derive(Debug)]
struct Hand {
    cards: Vec<Cards>,
    hand_rank: String,
}

impl Hand {
    fn new() -> Hand {
        Hand {
            cards: Vec::new(),
            hand_rank: String::from(""),
        }
    }

    fn add_card(&mut self, card: Cards) {
        self.cards.push(card);
    }

    fn get_cards(&self) -> &Vec<Cards> {
        &self.cards
    }

    fn sort_hand(&mut self) {
        self.cards.sort_by(|a, b| a.suit.cmp(&b.suit));
    }

    fn print_hand(&self) {
        let mut count = 0;
        for new_card in self.cards.iter() {
            print!("{}\t", new_card);
            count += 1;
            if count % 5 == 0 {
                println!();
            }
        }
    }

    fn rank_hand(&mut self) {
        let mut suit_counts = HashMap::new();
        let mut rank_counts = HashMap::new();
        self.hand_rank = String::from("Royal Straight Flush");

        for new_card in self.cards.iter() {
            let suit = new_card.suit;
            let rank = &new_card.rank;
            *suit_counts.entry(suit).or_insert(0) += 1;
            *rank_counts.entry(rank.clone()).or_insert(0) += 1;
        }

        if suit_counts.len() == 1 && rank_counts.len() == 5 {
            if self.is_royal_straight_flush(rank_counts.keys().cloned(), suit_counts.keys().next().unwrap().clone()) {
                self.hand_rank = String::from("Royal Straight Flush");
                return;
            }

            self.hand_rank = String::from("Straight Flush");
            return;
        }

        if suit_counts.len() == 1 && rank_counts.len() == 5 {
            if self.is_straight(rank_counts.keys().cloned()) {
                self.hand_rank = String::from("Straight Flush");
                return;
            }

            self.hand_rank = String::from("Flush");
            return;
        }

        if rank_counts.contains_key("4") {
            self.hand_rank = String::from("Four of a Kind");
            return;
        }

        if rank_counts.contains_key("3") && rank_counts.contains_key("2") {
            self.hand_rank = String::from("Full House");
            return;
        }

        if rank_counts.len() == 5 && self.is_straight(rank_counts.keys().cloned()) {
            self.hand_rank = String::from("Straight");
            return;
        }

        if rank_counts.contains_key("3") {
            self.hand_rank = String::from("Three of a Kind");
            return;
        }

        if rank_counts.contains_key("2") {
            let pair_count = rank_counts.values().filter(|&&count| count == 2).count();
            if pair_count == 2 {
                self.hand_rank = String::from("Two Pair");
            } else {
                self.hand_rank = String::from("Pair");
            }
            return;
        }

        self.hand_rank = String::from("High Card");
    }

    fn get_flush_suit(&self) -> char {
        let mut suit_counts = HashMap::new();
        for new_card in self.cards.iter() {
            let new_suit = new_card.suit;
            *suit_counts.entry(new_suit).or_insert(0) += 1;
        }

        for &new_suit in suit_counts.keys() {
            if suit_counts[&new_suit] >= 5 {
                return new_suit;
            }
        }

        ' '
    }

    fn is_royal_straight_flush(&self, ranks: HashSet<String>, suit: char) -> bool {
        ranks.contains("10") && ranks.contains("J") && ranks.contains("Q") && ranks.contains("K") && ranks.contains("A")
    }

    fn is_straight(&self, ranks: HashSet<String>) -> bool {
        let mut rank_values: Vec<i32> = ranks.into_iter().map(|new_rank| Cards::get_rank_value(&new_rank)).collect();
        rank_values.sort();

        let min = rank_values[0];
        let max = *rank_values.last().unwrap();

        (max - min == 4 && rank_values.len() == 5) || (ranks.contains("A") && ranks.contains("2") && ranks.contains("3") && ranks.contains("4") && ranks.contains("5"))
    }
}

#[derive(Debug)]
struct Player {
    name: String,
    hand: Hand,
}

impl Player {
    fn new(name: &str) -> Player {
        Player {
            name: String::from(name),
            hand: Hand::new(),
        }
    }

    fn adding_to_hand(&mut self, new_card: Cards) {
        self.hand.add_card(new_card);
    }

    fn get_name(&self) -> &str {
        &self.name
    }

    fn get_hand(&self) -> &Hand {
        &self.hand
    }
}

impl std::fmt::Display for Player {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.name)
    }
}

#[derive(Debug)]
struct PlayerRank {
    player: Player,
    rank: String,
    suit: char,
}

impl PlayerRank {
    fn new(player: Player, rank: &str, suit: char) -> PlayerRank {
        PlayerRank {
            player,
            rank: String::from(rank),
            suit,
        }
    }

    fn get_player(&self) -> &Player {
        &self.player
    }

    fn get_rank(&self) -> &str {
        &self.rank
    }

    fn get_suit(&self) -> char {
        self.suit
    }
}

impl Ord for PlayerRank {
    fn cmp(&self, other: &Self) -> Ordering {
        self.rank.cmp(&other.rank)
    }
}

impl PartialOrd for PlayerRank {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Eq for PlayerRank {}

impl PartialEq for PlayerRank {
    fn eq(&self, other: &Self) -> bool {
        self.rank == other.rank
    }
}

impl std::fmt::Display for PlayerRank {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{} - {} - Suit: {}", self.player, self.rank, self.suit)
    }
}

fn main() {
    // Create players
    let player1 = Player::new("Player 1");
    let player2 = Player::new("Player 2");

    // Create player ranks
    let player_rank1 = PlayerRank::new(player1.clone(), "Royal Straight Flush", 'S');
    let player_rank2 = PlayerRank::new(player2.clone(), "Straight Flush", 'H');

    // Compare player ranks
    match player_rank1.cmp(&player_rank2) {
        Ordering::Less => println!("Player 1 is ranked lower."),
        Ordering::Greater => println!("Player 1 is ranked higher."),
        Ordering::Equal => println!("Player 1 and Player 2 are ranked equally."),
    }
}


