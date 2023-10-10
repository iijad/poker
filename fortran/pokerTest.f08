program pokerTest

use CardModule


implicit none

    type(Card) :: myCard
    character(10) :: cardRank
    character(1) :: cardSuit

    ! Create a card
    myCard%rank = " A"
    myCard%suit = "S"

    ! Display the card
    call DisplayCard(myCard)
    

end program pokerTest
