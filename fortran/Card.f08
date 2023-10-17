! this class defines all of the methods to build a card, a deck, a hand, and a player

module CardModule
    implicit none
    
! Define the Card type
    type :: Card
        character(2) :: rank
        character(1)  :: suit
    end type Card

! Defining the constructor for a Card
    contains
        subroutine CreateCard(this, rank, suit)
            type(Card), intent(out) :: this
            character(2), intent(in) :: rank
            character(1), intent(in) :: suit
            this%rank = rank
            this%suit = suit
  end subroutine CreateCard

! Function to display a card
        subroutine DisplayCard(this)
            type(Card), intent(in) :: this
            character(20) :: card_str
            card_str = this%rank // "" // this%suit
            print *, card_str
  end subroutine DisplayCard
  
  ! Function to get the rank of the card
        subroutine GetRank(aCard, rank)
            type(Card), intent(in) :: aCard
            character(10), intent(out) :: rank
            rank = aCard%rank
        end subroutine GetRank
        
  ! Function to get the suit of the card
        subroutine GetSuit(aCard, suit)
            type(Card), intent(in) :: aCard
            character(1), intent(out) :: suit
            suit = aCard%suit
        end subroutine GetSuit
  
  ! Function to get the rank of the card
        subroutine GetRankValue(aCard, rankValue)
            type(Card), intent(in) :: aCard
            integer, intent(out) :: rankValue
            
            ! Defining a mapping of ranks to values
            select case (aCard%rank)
                case ("2")
                    rankValue = 2
                case ("3")
                    rankValue = 3
                case ("4")
                    rankValue = 4
                case ("5")
                    rankValue = 5
                case ("6")
                    rankValue = 6
                case ("7")
                    rankValue = 7
                case ("8")
                    rankValue = 8
                case ("9")
                    rankValue = 9
                case ("10")
                    rankValue = 10
                case ("J")
                    rankValue = 11
                case ("Q")
                    rankValue = 12
                case ("K")
                    rankValue = 13
                case ("A")
                    rankValue = 14
                case default
                    rankValue = -1 ! Invalid rank
            end select
        end subroutine GetRankValue
        
        
  ! Function to compare ranks of two cards
      subroutine CompareRanks(card1, card2, result)
          type(Card), intent(in) :: card1, card2
            integer, intent(out) :: result

            integer :: rankValue1, rankValue2
            call GetRankValue(card1, rankValue1)
            call GetRankValue(card2, rankValue2)

            if (rankValue1 < rankValue2) then
                result = -1
            elseif (rankValue1 > rankValue2) then
                result = 1
            else
                result = 0
            end if
        end subroutine CompareRanks

end module CardModule


! Deck Class

module DeckModule
    use CardModule
    implicit none
    
    ! Defining the Deck type
    type :: Deck
        type(Card), allocatable :: cards(:)
        integer :: topCard
        
    
    end type Deck
    
    contains
        subroutine CreateDeck(this)
            type(Deck), intent(out) :: this
            integer :: i, j
            integer, dimension(13) :: rankLengths
            
             ! Define ranks and suits
            character(13), dimension(13) :: allRanks
            character(4) :: allSuits(4) = ["S", "H", "D", "C"]
            
             ! Setting the rank names manually
            allRanks = ["2  ", "3  ", "4  ", "5  ", "6  ", "7  ", "8  ", "9  ", "10 ", "J  ", "Q  ", "K  ", "A  "]
            
            ! Padding shorter rank names with spaces to make them of length 10
            do i = 1, 13
                allRanks(i) = allRanks(i) // repeat(" ", 10 - len_trim(allRanks(i)))
            end do
            
            ! Compute the lengths of the rank names
            do i = 1, 13
                rankLengths(i) = len_trim(allRanks(i))
            end do
            
            ! Create the deck by combining ranks and suits
            allocate(this%cards(size(allRanks) * size(allSuits)))
            this%topCard = 0
            do i = 1, size(allSuits)
                do j = 1, size(allRanks)
                    this%topCard = this%topCard + 1
                    this%cards(this%topCard)%rank = allRanks(j)
                    this%cards(this%topCard)%suit = allSuits(i)
                end do
            end do
            
        end subroutine CreateDeck
        
        subroutine ShuffleDeck(this)
            type(Deck), intent(inout) :: this
            integer :: i, j
            type(Card) :: temp
            integer, dimension(8) :: seed
            
            ! Initialize the random number generator
            
            
            ! Making a random shuffle algorithm
            do i = 1, size(this%cards)
                call random_seed(get=seed)  ! Initialize the seed
                call random_seed(put=seed)  ! Set the seed
                j = i + int((size(this%cards) - i + 1) * rand())
                temp = this%cards(i)
                this%cards(i) = this%cards(j)
                this%cards(j) = temp
            end do
        end subroutine ShuffleDeck
        
        ! Defining a subroutine for dealing the cards
        subroutine DealCard(this, aCard)
            type(Deck), intent(inout) :: this
            type(Card), intent(out) :: aCard
            
            if (this%topCard > 0) then
                aCard = this%cards(this%topCard)
                this%topCard = this%topCard - 1
            else
                print *, "The deck is empty. No more cards to deal."
            end if
            end subroutine DealCard
            
        ! Deck size
        elemental function DeckSize(this) result(size)
            type(Deck), intent(in) :: this
            integer :: size
            size = this%topCard
        end function DeckSize
        
        ! Defining subroutine to print the deck
        subroutine PrintDeck(this)
            type(Deck), intent(in) :: this
            integer :: i
            do i = 1, this%topCard
                call DisplayCard(this%cards(i))
            end do
        end subroutine PrintDeck
        
        ! Defining subroutine to print the remainder of the deck
        subroutine PrintRemainingDeck(this)
            type(Deck), intent(in) :: this
            integer :: i
            do i = 1, this%topCard
                call DisplayCard(this%cards(i))
            end do
        end subroutine PrintRemainingDeck

end module DeckModule

! Hand class
module HandModule
    use CardModule
    implicit none
    
    ! Define the Hand type
    type :: Hand
        type(Card), allocatable :: cards(:)
        integer :: numCards
    end type Hand
    
   public :: CreateEmptyHand
    
    contains
        ! Constructor to create an empty hand
        subroutine CreateEmptyHand(this)
            type(Hand), intent(out) :: this
            this%numCards = 0
            allocate(this%cards(0))
        end subroutine CreateEmptyHand
        
        ! Method to add a card to a hand
        subroutine AddCard(this, aCard)
            type(Hand), intent(inout) :: this
            type(Card), intent(in) :: aCard
            this%numCards = this%numCards + 1
            allocate(this%cards(this%numCards))
            this%cards(this%numCards) = aCard
        end subroutine AddCard
        
        ! Method to return the cards in a hand
        subroutine GetCards(this, handCards)
            type(Hand), intent(in) :: this
            type(Card), dimension(:), allocatable, intent(out) :: handCards
            allocate(handCards(this%numCards))
            handCards = this%cards
        end subroutine GetCards
        
        ! Method to sort the hand by rank
        subroutine SortByRank(this)
            type(Hand), intent(inout) :: this
            integer :: i, j
            type(Card) :: temp
            
            do i = 1, this%numCards
                do j = i + 1, this%numCards
                    if (this%cards(i)%rank > this%cards(j)%rank) then
                        temp = this%cards(i)
                        this%cards(i) = this%cards(j)
                        this%cards(j) = temp
                    end if
                end do
            end do
        end subroutine SortByRank
        
        ! Method to compare two hands by their highest ranked card
        elemental function CompareHands(hand1, hand2) result(result)
            type(Hand), intent(in) :: hand1, hand2
            integer :: result
            
            
            ! Get the rank values for the highest ranked cards in each hand
            integer :: rankValue1, rankValue2
            
            
            ! Calculate rank value for the first hand's highest-ranked card
            select case (hand1%cards(hand1%numCards)%rank)
                case ("2")
                    rankValue1 = 2
                case ("3")
                    rankValue1 = 3
                case ("4")
                    rankValue1 = 4
                case ("5")
                    rankValue1 = 5
                case ("6")
                    rankValue1 = 6
                case ("7")
                    rankValue1 = 7
                case ("8")
                    rankValue1 = 8
                case ("9")
                    rankValue1 = 9
                case ("10")
                    rankValue1 = 10
                case ("J")
                    rankValue1 = 11
                case ("Q")
                    rankValue1 = 12
                case ("K")
                    rankValue1 = 13
                case ("A")
                    rankValue1 = 14
                case default
                    rankValue1 = -1 ! Invalid rank
            end select
            
            ! Calculate rank value for the second hand's highest-ranked card
            select case (hand2%cards(hand2%numCards)%rank)
                case ("2")
                    rankValue2 = 2
                case ("3")
                    rankValue2 = 3
                case ("4")
                    rankValue2 = 4
                case ("5")
                    rankValue2 = 5
                case ("6")
                    rankValue2 = 6
                case ("7")
                    rankValue2 = 7
                case ("8")
                    rankValue2 = 8
                case ("9")
                    rankValue2 = 9
                case ("10")
                    rankValue2 = 10
                case ("J")
                    rankValue2 = 11
                case ("Q")
                    rankValue2 = 12
                case ("K")
                    rankValue2 = 13
                case ("A")
                    rankValue2 = 14
                case default
                    rankValue2 = -1 ! Invalid rank
            end select

            
            
            if (rankValue1 < rankValue2) then
                result = -1
            elseif (rankValue1 > rankValue2) then
                result = 1
            else
                result = 0
            end if
        end function CompareHands
        
        ! Method to print the cards in a hand
        subroutine PrintHand(this)
            type(Hand), intent(in) :: this
            integer :: i
            do i = 1, this%numCards
                call DisplayCard(this%cards(i))
            end do
        end subroutine PrintHand
        
        ! ToString method to format the cards in a hand
        subroutine HandToString(this, handStr)
            type(Hand), intent(in) :: this
            character(20), allocatable, dimension(:) :: handStr
            character(20) :: cardStr
            integer :: i
            
            ! Allocate the character array to store card representations
            allocate(handStr(this%numCards))
            
            ! Loop through the cards and append their representations to the string
             do i = 1, this%numCards
                 call DisplayCard(this%cards(i))
                 write(cardStr, '(A, A)') this%cards(i)%rank, this%cards(i)%suit
                 handStr(i) = cardStr
             enddo
        end subroutine HandToString
        
      ! Function to rank the hand
      function RankHand(this) result(handRank)
        type(Hand), intent(in) :: this
        character(20) :: handRank
        
        ! Check for Royal Straight Flush
        if (IsRoyalStraightFlush(this)) then
         handRank = "Royal Straight Flush"
         return
        end if
        
        ! Check for Straight Flush
        if (IsStraightFlush(this)) then
          handRank = "Straight Flush"
          return
        end if
        
        ! Check for Four of a Kind
        if (IsFourOfAKind(this)) then
          handRank = "Four of a Kind"
          return
        end if
        
         ! Check for Full House
         if (IsFullHouse(this)) then
           handRank = "Full House"
           return
         end if
         
         ! Check for Flush
         if (IsFlush(this)) then
           handRank = "Flush"
           return
         end if
         
         ! Check for Straight
         if (IsStraight(this)) then
           handRank = "Straight"
           return
         end if
         
         ! Check for Three of a Kind
         if (IsThreeOfAKind(this)) then
           handRank = "Three of a Kind"
           return
         end if
         
         ! Check for Two Pair
         if (IsTwoPair(this)) then
           handRank = "Two Pair"
           return
         end if
         
         ! Check for a Pair
         if (IsPair(this)) then
           handRank = "Pair"
           return
         end if
         
         ! Default to High Card
         handRank = "High Card"
      end function RankHand
      
        ! Check for Royal Straight Flush
        function IsRoyalStraightFlush(this) result(isRoyalRStraightFlush)
          type(Hand), intent(in) :: this
          logical :: isRoyalRStraightFlush
          logical :: hasAce
          integer :: i
          integer, parameter :: numRanks = 13
          character(1), dimension(numRanks) :: allRanks = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
          
          isRoyalRStraightFlush = .false.
          hasAce = .false.

          
        ! Check for Straight Flush
        if (IsStraightFlush(this)) then
          ! Check for Ace ("A") in the hand
          do i = 1, this%numCards
            if (this%cards(i)%rank == "A") then
              hasAce = .true.
              exit
            end if
          end do
        end if
        
        ! If it's a straight flush and has an Ace, it's a Royal Straight Flush
        isRoyalRStraightFlush = IsStraightFlush(this) .and. hasAce
      end function IsRoyalStraightFlush
      
      ! Check for a Straight Flush
      function IsStraightFlush(this) result(isStraightFlushh)
          type(Hand), intent(in) :: this
          logical :: isStraightFlushh

          ! Check for both a straight and a flush
          isStraightFlushh = IsFlush(this) .and. IsStraight(this)
      end function IsStraightFlush
      
      ! Check for Four of a Kind
      function IsFourOfAKind(this) result(isFourrOfAKind)
        type(Hand), intent(in) :: this
        logical :: isFourrOfAKind
        integer :: i, j
        integer, parameter :: numRanks = 13
        character(1), dimension(numRanks) :: allRanks = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
        
        ! Group cards by rank
        integer :: rankCount(13) = 0
        
        isFourrOfAKind = .false.
        
        do i = 1, this%numCards
        do j = 1, 13
          if (this%cards(i)%rank == allRanks(j)) then
            rankCount(j) = rankCount(j) + 1
            if (rankCount(j) == 4) then
              isFourrOfAKind = .true.
              return
            end if
          end if
        end do
      end do
    end function IsFourOfAKind
    
    ! Check for Full House
    function IsFullHouse(this) result(isFulllHouse)
      type(Hand), intent(in) :: this
      logical :: isFulllHouse
      logical :: hasThreeOfAKind, hasPair
      integer :: i, j
      integer, parameter :: numRanks = 13
      character(1), dimension(numRanks) :: allRanks = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
      
      ! Group cards by rank
      integer :: rankCount(13) = 0
      
      isFulllHouse = .false.
      hasThreeOfAKind = .false.
      hasPair = .false.
      
      do i = 1, this%numCards
        do j = 1, 13
          if (this%cards(i)%rank == allRanks(j)) then
            rankCount(j) = rankCount(j) + 1
            if (rankCount(j) == 3) then
              hasThreeOfAKind = .true.
            else if (rankCount(j) == 2) then
              hasPair = .true.
            end if
          end if
        end do
      end do
      
      isFulllHouse = hasThreeOfAKind .and. hasPair
    end function IsFullHouse  
    
    ! Check for Flush
    function IsFlush(this) result(isFlushs)
      type(Hand), intent(in) :: this
      logical :: isFlushs
      integer :: i
      isFlushs = .true.
      do i = 2, this%numCards
        if (this%cards(i)%suit /= this%cards(1)%suit) then
          isFlushs = .false.
          exit
        end if
      end do
    end function IsFlush 
    
    ! Check for Three of a Kind
    function IsThreeOfAKind(this) result(isThreeeOfAKind)
        type(Hand), intent(in) :: this
        logical :: isThreeeOfAKind
        integer, parameter :: numRanks = 13
        character(1), dimension(numRanks) :: allRanks = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]

        ! Group cards by rank
        integer :: rankCount(13) = 0
        integer :: i, j

        isThreeeOfAKind = .false.

        do i = 1, this%numCards
            do j = 1, 13
                if (this%cards(i)%rank == allRanks(j)) then
                    rankCount(j) = rankCount(j) + 1
                    if (rankCount(j) == 3) then
                        isThreeeOfAKind = .true.
                    end if
                end if
            end do
        end do
    end function IsThreeOfAKind
    
    ! Check for Straight
    function IsStraight(this) result(isStraightt)
      type(Hand), intent(in) :: this
      logical :: isStraightt
      logical, dimension(13) :: rankExists
      integer :: i, j, rankValue, prevRankValue
      
      isStraightt = .false.
      rankExists = .false.

      ! Mark the existence of ranks
      do i = 1, this%numCards
        call GetRankValue(this%cards(i), rankValue)
        rankExists(rankValue) = .true.
      end do
      
      
      ! Check for a sequence of five consecutive ranks
      do i = 1, 9
        if (all(rankExists(i:i+4))) then
          isStraightt = .true.
          exit
        end if
      end do
    end function IsStraight
    
    ! Check for Two Pair
    function IsTwoPair(this) result(isTwoPairr)
        type(Hand), intent(in) :: this
        logical :: isTwoPairr
        integer, parameter :: numRanks = 13
        character(1), dimension(numRanks) :: allRanks = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]

        ! Group cards by rank
        integer :: rankCount(13) = 0
        integer :: i, j
        integer :: pairCount = 0

        isTwoPairr = .false.
        do i = 1, this%numCards
          do j = 1, 13
              if (this%cards(i)%rank == allRanks(j)) then
                  rankCount(j) = rankCount(j) + 1
                  if (rankCount(j) == 2) then
                      pairCount = pairCount + 1
                  end if
              end if
          end do
      end do
      
      if (pairCount == 2) then
        isTwoPairr = .true.
    end if
  end function IsTwoPair
  
  ! Check for a Pair
  function IsPair(this) result(isPairr)
      type(Hand), intent(in) :: this
      logical :: isPairr
      integer, parameter :: numRanks = 13
      character(1), dimension(numRanks) :: allRanks = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]

      ! Group cards by rank
      integer :: rankCount(13) = 0
      integer :: i, j
      integer :: pairCount = 0

      isPairr = .false.

      do i = 1, this%numCards
          do j = 1, 13
              if (this%cards(i)%rank == allRanks(j)) then
                  rankCount(j) = rankCount(j) + 1
                  if (rankCount(j) == 2) then
                      isPairr = .true.
                  end if
              end if
          end do
      end do
  end function IsPair
   
end module HandModule

! Player Class

module PlayerModule
    use HandModule
    implicit none

    type :: Player
        character(50) :: name
        type(Hand), allocatable :: hand
    end type Player

    contains


        function GetName(this) result(playerName)
            class(Player), intent(in) :: this
            character(50) :: playerName
            playerName = this%name
        end function GetName

        function GetHand(this) result(playerHand)
            class(Player), intent(in) :: this
            type(Hand) :: playerHand
            playerHand = this%hand
        end function GetHand

        function ToString(this) result(playerString)
            class(Player), intent(in) :: this
            character(100) :: playerString
            playerString = this%name
        end function ToString

end module PlayerModule