program pokerTest
    use CardModule
    use DeckModule
    use HandModule
    use PlayerModule
    implicit none
    
    ! This program is meant to use the Modules as seen above to create 6 players and give 
    ! them a hand of 5 cards each and then ranks them according to the rules of 5 card stud
    
    integer, parameter :: numPlayers = 6
    integer, parameter :: numCardsPerHand = 5
    
    
    ! Create a new deck of cards and new players
    type(Deck) :: newdeck
    type(Player), dimension(numPlayers) :: players
    
    ! Create a new deck
    !call newdeck%CreateDeck()
    
    ! Shuffles the deck
    !call newdeck%ShuffleDeck()

    ! Print the shuffled deck
    !print *, "Shuffled Deck:"
    !call newdeck%PrintDeck()
    
    ! Print all hands
    !do i = 1, numPlayers
        !print *, "Hand for ", players(i)%GetName(), ":"
        !call players(i)%GetHand()%PrintHand()
        !print *, "---------------------"
    !end do
    
    ! Print the shuffled deck
    !print *, "Shuffled Deck:"
    !call deck%PrintDeck()

    ! Create players and deal cards
    !do i = 1, numPlayers
       ! character(50) :: playerName
       ! playerName = "Player" // trim(adjustl(i))
        !call players(i)%InitializePlayer(playerName)
        !do j = 1, numCardsPerHand
           ! type(Card) :: aCard
            !call deck%DealCard(aCard)
            !call players(i)%AddToHand(aCard)
        !end do
    !end do

    ! Print all hands
    !do i = 1, numPlayers
       ! print *, "Hand for ", players(i)%GetName(), ":"
        !call players(i)%GetHand()%PrintHand()
       ! print *, "---------------------"
    !end do

    ! Rank and sort hands
    !integer, dimension(numPlayers) :: handRanks
    !do i = 1, numPlayers
      !  handRanks(i) = players(i)%GetHand()%RankHand()
    !end do

    ! Sort players by hand ranks (in descending order)
   ! do i = 1, numPlayers - 1
       ! do j = i + 1, numPlayers
           ! if (handRanks(i) < handRanks(j)) then
            !    ! Swap players and hand ranks
            !    type(Player) :: tempPlayer
            !    integer :: tempRank
            !    tempPlayer = players(i)
            !    tempRank = handRanks(i)
             !   players(i) = players(j)
            !    handRanks(i) = handRanks(j)
            !    players(j) = tempPlayer
           !     handRanks(j) = tempRank
          !  end if
      !  end do
    !end do

    ! Print ranked hands
    !print *, "Ranked Hands:"
   ! do i = 1, numPlayers
       ! print *, players(i)%GetName(), " - Rank:", handRanks(i)
    !end do

    ! Print the remainder of the deck
    !print *, "Remaining Deck:"
    !call deck%PrintRemainingDeck()

    
    

    

end program pokerTest
