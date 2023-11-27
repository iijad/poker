using Random

# Cards Type
struct Cards
    rank::String
    suit::String
end

function Cards(rank::String, suit::String)
    return Cards(rank, suit)
end

get_rank(card::Cards) = card.rank
get_suit(card::Cards) = card.suit

Base.:<(card1::Cards, card2::Cards) = get_rank(card1) < get_rank(card2)

Base.show(io::IO, card::Cards) = print(io, get_rank(card), get_suit(card))

function get_rank_value(rank::String)
    rank_values = Dict(
        "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7,
        "8" => 8, "9" => 9, "10" => 10, "J" => 11, "Q" => 12, "K" => 13, "A" => 14
    )
    return get(rank_values, rank, -1)
end

# Deck Type
mutable struct Deck
    cards::Vector{Cards}

    function Deck()
        cards = Cards[]
        suits = ['S', 'H', 'D', 'C']
        ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

        for suit in suits
            for rank in ranks
                push!(cards, Cards(rank, suit))
            end
        end

        return new(cards)
    end
end

function shuffle!(deck::Deck)
    Random.shuffle!(deck.cards)
end

function deal_card(deck::Deck)
    if !isempty(deck.cards)
        return popfirst!(deck.cards)
    end
    return nothing
end

size(deck::Deck) = length(deck.cards)

function print_deck(deck::Deck)
    count = 0
    for card in deck.cards
        print(card, "\t")
        count += 1
        if count % 13 == 0
            println()
        end
    end
end

function print_remaining_deck(deck::Deck)
    println("\nRemaining Cards in Deck:\t", "")
    for card in deck.cards
        println(card, "\t")
    end
    println()
end

# Hand Type
mutable struct Hand
    cards::Vector{Cards}
end

function Hand()
    return Hand(Cards[])
end

function add_card(hand::Hand, card::Cards)
    push!(hand.cards, card)
end

function get_cards(hand::Hand)
    return hand.cards
end

function sort_hand!(hand::Hand)
    sort!(hand.cards, by = card -> get_suit(card))
end

Base.:<(hand1::Hand, hand2::Hand) = rank_hand(hand1) < rank_hand(hand2)

function print_hand(hand::Hand)
    count = 0
    for card in hand.cards
        print(card, "\t")
        count += 1
        if count % 5 == 0
            println()
        end
    end
end

Base.show(io::IO, hand::Hand) = join(map(string, hand.cards), "\t")

function rank_hand(hand::Hand)
    suit_counts = Dict()
    rank_counts = Dict()
    hand_rank = "Royal Straight Flush"

    for card in hand.cards
        suit = get_suit(card)
        rank = get_rank(card)
        suit_counts[suit] = get(suit_counts, suit, 0) + 1
        rank_counts[rank] = get(rank_counts, rank, 0) + 1
    end

    if length(suit_counts) == 1 && length(rank_counts) == 5
        if is_royal_straight_flush(keys(rank_counts), first(keys(suit_counts)))
            return "Royal Straight Flush"
        end
        return "Straight Flush"
    end

    if length(suit_counts) == 1 && length(rank_counts) == 5
        if is_straight(keys(rank_counts))
            return "Straight Flush"
        end
        return "Flush"
    end

    if 4 in values(rank_counts)
        return "Four of a Kind"
    end

    if 3 in values(rank_counts) && 2 in values(rank_counts)
        return "Full House"
    end

    if length(rank_counts) == 5 && is_straight(keys(rank_counts))
        return "Straight"
    end

    if 3 in values(rank_counts)
        return "Three of a Kind"
    end

    if 2 in values(rank_counts)
        pair_count = count(x -> x == 2, values(rank_counts))
        if pair_count == 2
            return "Two Pair"
        else
            return "Pair"
        end
    end

    return "High Card"
end

function is_royal_straight_flush(ranks, suit)
    return all(rank in ranks for rank in ["10", "J", "Q", "K", "A"])
end

function is_straight(ranks)
    rank_values = [get_rank_value(rank) for rank in ranks]
    sort!(rank_values)
    min_rank = first(rank_values)
    max_rank = last(rank_values)

    if max_rank - min_rank == 4 && length(ranks) == 5
        return true
    end

    if "A" in ranks && "2" in ranks && "3" in ranks && "4" in ranks && "5" in ranks
        return true
    end

    return false
end

function get_flush_suit(hand::Hand)
    suit_counts = Dict()
    for card in hand.cards
        suit = get_suit(card)
        suit_counts[suit] = get(suit_counts, suit, 0) + 1
    end

    for (suit, count) in suit_counts
        if count >= 5
            return suit
        end
    end

    return nothing  # No flush suit found
end

# Player Type
mutable struct Player
    name::String
    hand::Hand
end

function Player(name::String)
    return Player(name, Hand())
end

function add_to_hand(player::Player, card::Cards)
    add_card(player.hand, card)
end

get_name(player::Player) = player.name

get_hand(player::Player) = player.hand

Base.show(io::IO, player::Player) = player.name

# PlayerRank Type
mutable struct PlayerRank
    player::Player
    rank::String
    suit::String
end

get_player(player_rank::PlayerRank) = player_rank.player

get_rank(player_rank::PlayerRank) = player_rank.rank

Base.:<(player_rank1::PlayerRank, player_rank2::PlayerRank) = get_rank(player_rank1) < get_rank(player_rank2)

get_suit(player_rank::PlayerRank) = player_rank.suit