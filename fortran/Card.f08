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






end module CardModule
