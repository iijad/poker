program pokerTest

use CardModule


implicit none

    type(Card) :: myCard

    ! Create a card
    myCard%rank = " A"
    myCard%suit = "S"

    ! Display the card
    call DisplayCard(myCard)

end program pokerTest
