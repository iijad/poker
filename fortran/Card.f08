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
