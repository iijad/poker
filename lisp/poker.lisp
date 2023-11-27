(defclass poker ()
  ()
  (:default-initargs)
  (:metaclass persistent))

(defun main (args)
  (let ((deck (make-instance 'Deck))
        (players (make-players 6))
        (player-ranks nil))
    (if (null args)
        (progn
          (format t "*** P O K E R   H A N D   A N A L Y Z E R ***~%")
          (format t "*** USING RANDOMIZED DECK OF CARDS ***~%")
          (format t "*** Shuffled 52 card deck:~%")
          (deck-print-deck deck))
        (progn
          (format t "*** P O K E R   H A N D   A N A L Y Z E R ***~%")
          (format t "*** USING TEST DECK ***~%")
          (let* ((file (first args))
                 (all-hands (read-deck-from-file file)))
            (if (not (enough-cards-to-make-hands all-hands))
                (format t "Not enough cards to make a hand.~%")
                (format t "*** Here are the six hands...~%")
                (loop for i from 0 to 5 do
                      (let ((hand (nth i all-hands)))
                        (format t "~{~a~^ ~}\t~%" (mapcar #'card-to-string hand)))))))
    (deal-hands deck players)
    (format t "*** Calculating and storing ranks for each player's hand ***~%")
    (loop for player in players do
          (let* ((hand (get-hand player))
                 (hand-ranks (rank-hand hand))
                 (flush-suit (get-flush-suit hand)))
            (format t "~a's hand:~%" (get-name player))
            (hand-print-hand hand)
            (format t " - ~a~%" hand-ranks)
            (format t "Flush Suit: ~a~%" flush-suit)
            (format t "~%")
            (push (make-instance 'PlayerRank :player player :rank hand-ranks :suit flush-suit) player-ranks)))
    (format t "*** Sorting players in order of hand ranks ***~%")
    (setf player-ranks (sort player-ranks #'> :key #'rank-comparator))
    (format t "*** WINNING HAND ORDER ***~%")
    (loop for player-rank in player-ranks do
          (let* ((player (get-player player-rank))
                 (hand (get-hand player)))
            (format t "~a's hand:~%" (get-name player))
            (hand-sort-hand hand)
            (hand-print-hand hand)
            (format t " - ~a~%" (get-rank player-rank))
            (format t "~%")))
    (deck-print-remaining-deck deck)))

(defun make-players (num)
  (loop for i from 1 to num collect
        (make-instance 'Player :name (format nil "Player ~a" i))))

(defun enough-cards-to-make-hands (all-hands)
  (every (lambda (hand) (= (length hand) 5)) all-hands))

(defun read-deck-from-file (file)
  (with-open-file (stream file :direction :input)
    (loop with all-hands = nil
          for line = (read-line stream nil)
          while line
          do (let ((cards (parse-cards-from-line line)))
               (push cards all-hands))
          finally (return (nreverse all-hands)))))

(defun parse-cards-from-line (line)
  (loop for card-str in (split-sequence:split-sequence #\, line)
        collect (make-instance 'Cards :rank (subseq card-str 0 (min 2 (length card-str)))
                                :suit (char (if (= (length card-str) 3) (char card-str 2) #\Space)))))

(defun deck-print-deck (deck)
  (loop for card in (get-cards deck) do
        (format t "~a\t" card)
        (when (= (% (incf count) 13) 0) (format t "~%"))))

(defun deck-print-remaining-deck (deck)
  (format t "*** Here is what remains in the deck...: ~t~%")
  (loop for card in (get-cards deck) do
        (format t "~a\t" card)))

(defun deal-hands (deck players)
  (loop repeat 5 do
        (loop for player in players do
              (let ((new-card (deck-dealing-cards deck)))
                (when new-card
                  (player-adding-to-hand player new-card))))))

(defun rank-comparator (player-rank)
  (list (get-rank player-rank) (get-suit player-rank) (get-name (get-player player-rank))))

(main *command-line-arguments*)
