using Random

# Define the types and functions as provided in the previous response

# Function to read cards from a file
function read_cards_from_file(filename::String)
    cards = Cards[]
    try
        file = open(filename, "r")
        for line in eachline(file)
            rank, suit = split(line)
            push!(cards, Cards(rank, suit))
        end
        close(file)
    catch
        println("Error reading file. Generating a shuffled deck instead.")
        return Deck()
    end
    return cards
end

# Function to deal hands to players
function deal_hands(deck::Deck, num_players::Int, cards_per_hand::Int)
    players = [Player("Player $i") for i in 1:num_players]
    for _ in 1:cards_per_hand
        for player in players
            card = deal_card(deck)
            add_to_hand(player, card)
        end
    end
    return players
end

# Function to rank and print hands
function rank_and_print_hands(players::Vector{Player})
    for player in players
        sort_hand!(get_hand(player))
        println("Player $(get_name(player)):")
        print_hand(get_hand(player))
        println("Hand Rank: ", rank_hand(get_hand(player)))
        println("\n")
    end
end

# Main program
function main(args)
    if length(args) > 0
        filename = args[1]
        cards = read_cards_from_file(filename)
    else
        cards = Deck()
        shuffle!(cards)
    end

    num_players = 3
    cards_per_hand = 5

    players = deal_hands(cards, num_players, cards_per_hand)

    rank_and_print_hands(players)
end

# Run the main program with command line arguments if provided
main(ARGS)
