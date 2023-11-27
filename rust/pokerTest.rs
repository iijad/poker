#!/usr/bin/rust
use std::collections::{HashSet, HashMap};
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    let mut deck = Deck::new();
    deck.shuffle();

    let args: Vec<String> = std::env::args().collect();

    if args.len() == 1 {
        println!("*** P O K E R   H A N D   A N A L Y Z E R ***");
        println!();
        println!("*** USING RANDOMIZED DECK OF CARDS ***");
        println!();
        println!("*** Shuffled 52 card deck: ");
    } else {
        println!("*** P O K E R   H A N D   A N A L Y Z E R ***");
        println!();
        println!("*** USING TEST DECK ***");
        let file = &args[1];
        read_deck_from_file(file);
        return;
    }

    let num_players = 6;
    let cards_per_hand = 5;
    let mut players: Vec<Player> = (1..=num_players).map(|i| Player::new(format!("Player {}", i))).collect();
    let mut player_ranks: Vec<PlayerRank> = Vec::new();

    for _ in 0..cards_per_hand {
        for player in players.iter_mut() {
            if let Some(new_card) = deck.dealing_cards() {
                player.adding_to_hand(new_card);
            } else {
                println!("The deck is empty.");
                break;
            }
        }
    }

    player_ranks.sort();

    println!("Here are the six hands... ");
    for new_player in players.iter() {
        new_player.get_hand().print_hand();
        let hand_ranks = new_player.get_hand().rank_hand();
        let flush_suit = new_player.get_hand().get_flush_suit();
        println!();
        player_ranks.push(PlayerRank::new(new_player.clone(), hand_ranks, flush_suit));
    }

    player_ranks.sort_by(|pr1, pr2| {
        let rank_compare = pr2.get_rank().cmp(pr1.get_rank());

        if rank_compare == std::cmp::Ordering::Equal {
            if pr1.get_rank() == "Straight" && pr2.get_rank() == "Straight" {
                return compare_suits(pr1.get_suit(), pr2.get_suit());
            } else if pr1.get_rank() == "Two Pair" && pr2.get_rank() == "Two Pair" {
                let kicker_compare = compare_suits(pr1.get_suit(), pr2.get_suit());
                if kicker_compare == std::cmp::Ordering::Equal {
                    return pr1.get_player().get_name().cmp(pr2.get_player().get_name());
                }
                return kicker_compare;
            } else if pr1.get_rank() == "Pair" && pr2.get_rank() == "Pair" {
                return compare_suits(pr1.get_suit(), pr2.get_suit());
            } else if pr1.get_rank() == "High Card" && pr2.get_rank() == "High Card" {
                let high_card = compare_suits(pr1.get_suit(), pr2.get_suit());
                if high_card == std::cmp::Ordering::Equal {
                    return pr1.get_player().get_name().cmp(pr2.get_player().get_name());
                }
            } else {
                let suit_compare = compare_suits(pr1.get_suit(), pr2.get_suit());
                if suit_compare == std::cmp::Ordering::Equal {
                    return pr1.get_player().get_name().cmp(pr2.get_player().get_name());
                }
                return suit_compare;
            }
        }

        return rank_compare;
    });

    deck.print_remaining_deck();
    println!();
    println!();
    println!("--- WINNING HAND ORDER ---");
    for new_player_rank in player_ranks.iter() {
        new_player_rank.get_player().get_hand().sort_hand();
        new_player_rank.get_player().get_hand().print_hand();
        println!(" - {}", new_player_rank.get_rank());
        println!();
    }
}

// Comparing suits in case of a tie
fn compare_suits(suit1: char, suit2: char) -> std::cmp::Ordering {
    let suit_order = "DCHS"; // The order is Diamonds, Clubs, Hearts, Spades
    return suit_order.chars().position(|c| c == suit1).unwrap().cmp(&suit_order.chars().position(|c| c == suit2).unwrap());
}

// Method for reading in the file to create the hands and print them
fn read_deck_from_file(file_path: &str) {
    let path = Path::new(file_path);
    let file = match File::open(&path) {
        Err(_) => {
            println!("Error reading the file.");
            return;
        }
        Ok(file) => file,
    };

    let reader = io::BufReader::new(file);
    let mut all_hands: Vec<Vec<Cards>> = Vec::new();
    let mut unique_cards: HashSet<String> = HashSet::new();

    println!("File Name: {}", file_path);
    for line in reader.lines() {
        let line = match line {
            Err(_) => continue,
            Ok(line) => line,
        };

        println!("{}", line);

        let card_records: Vec<&str> = line.split(",").collect();
        if card_records.len() != 5 {
            println!("Invalid card record: {}", card_records.join(","));
            continue;
        }

        for card_record in &card_records {
            if unique_cards.contains(*card_record) {
                println!("*** ERROR - DUPLICATE CARD FOUND IN DECK ***");
                println!("DUPLICATE: {}", card_record);
                std::process::exit(1);
            }
            unique_cards.insert(card_record.to_string());
        }

        if card_records.len() == 5 {
            let new_hand: Vec<Cards> = card_records
                .iter()
                .map(|&card_str| {
                    let (rank, suit) = if card_str.len() == 2 {
                        (card_str.get(0..1).unwrap(), card_str.get(1..2).unwrap())
                    } else if card_str.len() == 3 {
                        (card_str.get(0..2).unwrap(), card_str.get(2..3).unwrap())
                    } else {
                        println!("Invalid card format: {}", card_str);
                        return Cards::new("", ' ');
                    };
                    Cards::new(rank, suit.chars().next().unwrap())
                })
                .collect();
            all_hands.push(new_hand);
        }
    }

    if all_hands.len() < 5 {
        println!("Not enough cards to make a hand.");
    } else {
        println!();
        println!("*** Here are the six hands...");
        for i in 0..6 {
            let hand = &all_hands[i];
            for card in hand {
                print!("{}\t", card);
            }
            println!();
        }
    }
}